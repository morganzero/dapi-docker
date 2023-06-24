# Dockerized Linux-Apache-PHP Stack for Traefik Reverse Proxy

This Docker container provides a pre-configured Linux-Apache-PHP (LAMP) stack, allowing you to easily deploy web applications such as WHMCS or other similar platforms behind a Traefik reverse proxy. With Traefik, you can efficiently manage incoming requests and route them to the appropriate container.

## Prerequisites

Before you begin, ensure that you have the following components installed:

- Docker: [Installation Guide](https://docs.docker.com/get-docker/)
- Traefik: [Installation Guide](https://doc.traefik.io/traefik/)

## Deployment

To deploy the LAMP stack container with Traefik, follow these steps:

1. Create a `docker-compose.yml` file in your desired directory and copy the following content into it:

\`\`\`yaml
version: "3.9"
services:
  fossbilling:
    image: docker.io/sushibox/dapi:latest
    restart: always
    ports:
      - 80:80
    volumes:
      - /opt/dapi:/var/www/html

  mariadb:
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: whmcs
      MYSQL_USER: whmcs
      MYSQL_PASSWORD: whmcs
      MYSQL_RANDOM_ROOT_PASSWORD: whmcs
    volumes:
      - /opt/dapi/db:/var/lib/mysql

volumes:
  mysql:
\`\`\`

2. Save the `docker-compose.yml` file.

3. Open a terminal or command prompt, navigate to the directory where you saved the `docker-compose.yml` file, and run the following command:

\`\`\`bash
docker-compose up -d
\`\`\`

4. Wait for the container to start and verify that it's running without any errors by running:

\`\`\`bash
docker-compose ps
\`\`\`

## Configuration

By default, this container exposes port 80, allowing HTTP traffic to reach your web application. Ensure that you have set up Traefik correctly to handle incoming requests and route them to this container.

If you wish to customize the configuration or add additional services, you can modify the `docker-compose.yml` file accordingly.

## Volumes

This container uses the following volumes:

- `/var/www/html`: Mount this volume to persistently store your web application files.
- `/var/lib/mysql`: Mount this volume to persistently store the MariaDB database files.

You can adjust the volume paths in the `docker-compose.yml` file to match your desired locations on the host machine.

## Troubleshooting

If you encounter any issues or need further assistance, consider checking the following:

- Make sure you have the necessary permissions to bind ports and access the specified volumes.
- Verify that Traefik is properly configured and routes traffic to the correct container.

## License

This project is licensed under the [MIT License](LICENSE).

---

We hope you find this Dockerized LAMP stack container helpful for deploying your web applications with ease. If you have any questions or feedback, please don't hesitate to reach out. Happy coding!
