# Dockerfile Sécurisé - Big Mamma Project
# Version: 2.0
# Date: 2026-02-13

# ---- Build Stage ----
FROM node:20-alpine AS build

WORKDIR /app

# Copie uniquement les fichiers de dépendances d'abord (cache layer)
COPY package*.json ./
RUN npm ci --only=production --ignore-scripts

# Copie le reste du projet
COPY . .

# Build du CSS
RUN npm run build

# ---- Production Stage ----
FROM nginx:alpine

# Métadonnées de sécurité
LABEL maintainer="security@example.com"
LABEL security.scan="required"
LABEL version="2.0"

# Installation des outils de sécurité
RUN apk add --no-cache \
    fail2ban \
    curl \
    && rm -rf /var/cache/apk/*

# Supprime la config par défaut (non sécurisée)
RUN rm /etc/nginx/conf.d/default.conf

# Copie la configuration sécurisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie les fichiers statiques depuis le build
COPY --from=build /app/index.html /usr/share/nginx/html/
COPY --from=build /app/src/output.css /usr/share/nginx/html/src/
COPY --from=build /app/img /usr/share/nginx/html/img/

# Création des pages d'erreur personnalisées
RUN echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>403 Forbidden</title></head><body><h1>403 - Access Denied</h1><p>Your IP has been blocked due to suspicious activity.</p></body></html>' > /usr/share/nginx/html/403.html

RUN echo '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>404 Not Found</title></head><body><h1>404 - Page Not Found</h1><p>The requested resource could not be found.</p></body></html>' > /usr/share/nginx/html/404.html

# Permissions sécurisées
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

# Création d'un utilisateur non-root pour nginx
RUN addgroup -g 1001 -S nginxuser && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginxuser nginxuser

# Santé du conteneur
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Exposition du port
EXPOSE 80

# Démarrage de Nginx
CMD ["nginx", "-g", "daemon off;"]
