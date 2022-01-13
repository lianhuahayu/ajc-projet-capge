FROM python:3.6-alpine

LABEL maintainer=CAPGEMINI

# Configuration du répertoire de travail
WORKDIR /opt/ic-webapp/

# Copier les fichiers de notre projet dans notre répertoire de travail
COPY . /opt/ic-webapp/

# Set variables env ODOO_URL and PGADMIN_URL
ENV ODOO_URL='https://www.odoo.com/'
ENV PGADMIN_URL='https://www.pgadmin.org/'

# Test variables env ODOO_URL and PGADMIN_URL
# Pendant le build de l'image : 
# Vérifiez que ces variables ont bien pris les valeurs précédentes 
RUN echo ${ODOO_URL}
RUN echo ${PGADMIN_URL}

# Installation Flask avec pip car l'application utilise flask
RUN pip install flask

# Exposition du port 8080 pour l'API
EXPOSE 8080

# Start le serveur et lancer l'application
ENTRYPOINT [ "python", "app.py" ]