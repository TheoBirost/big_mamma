# ---- Build ----
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# ---- Nginx ----
FROM nginx:alpine

# Supprime la config par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Ajoute notre config
COPY nginx.conf /etc/nginx/conf.d

# Copie les fichiers statiques
# Comme ce n'est pas un projet Vue/Vite qui build dans dist, on copie les fichiers nécessaires
COPY --from=build /app/index.html /usr/share/nginx/html/
COPY --from=build /app/src/output.css /usr/share/nginx/html/src/
COPY --from=build /app/img /usr/share/nginx/html/img

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]