# UPT Eventos App
- Corrales Solis, Moisés Alessandro
- Viveros Blanco, Farley Eduardo
- Poma Manchego, Rene Manuel
  
## Descripción
UPT Eventos es un aplicativo móvil diseñado para la gestión y presentación de Juegos Florales, abarcando disciplinas como canto, baile y declamación. Desarrollado en Dart utilizando Flutter, el sistema está basado en una arquitectura de microservicios para ofrecer escalabilidad y flexibilidad.

## Obtener APK
https://appmovilflorales.blob.core.windows.net/apkjuegosflorales/JuegosFlorales.apk

## Características
- Visualización de eventos universitarios
- Información detallada de equipos y sus participantes
- Lista de coordinadores (estudiantes y docentes)
- Ubicaciones de eventos con integración de mapas
- Interfaz intuitiva y fácil de usar
  
## Objetivos
- Desarrollar una plataforma móvil que centralice información sobre las disciplinas de los Juegos Florales.
- Implementar microservicios para gestionar el flujo de datos y la interacción entre componentes.
- Proveer una experiencia de usuario intuitiva para inscripción y consulta de información.
- Facilitar la organización del evento mediante herramientas administrativas accesibles

## Tecnologías Utilizadas
- Lenguaje de programación: Dart
- Framework: Flutter
- Microservicios: Node.js y Express
- Base de datos: MongoDB
- Herramientas de desarrollo: Visual Studio Code, Postman, GitHub
- Plataforma de despliegue: Heroku o AWS

## Alacance
El aplicativo incluye:

- Registro de participantes y disciplinas.
- Visualización de horarios y eventos.
- Notificaciones en tiempo real.
- Administración de jurados y evaluación de performances.

## Instalación
1. Clona este repositorio:
git clone https://github.com/tu-usuario/upt-eventos-app.git

2. Navega al directorio del proyecto:
cd upt-eventos-app

3. Instala las dependencias:
flutter pub get

4. Ejecuta la aplicación:
flutter run

El desarrollo comenzó con la definición de requerimientos y la creación de una arquitectura de microservicios. Se implementaron endpoints RESTful para la interacción entre la aplicación y el backend. La interfaz de usuario se diseñó para ser intuitiva, y se integraron notificaciones push para mantener a los usuarios informados sobre cambios relevantes.

## Uso
Después de iniciar la aplicación, podrás:
Ver la lista de eventos próximos
Explorar equipos y sus participantes
Consultar información de coordinadores
Ver ubicaciones de eventos en el mapa

El aplicativo móvil para los Juegos Florales es una solución innovadora que mejora la organización y gestión de eventos culturales. La arquitectura de microservicios optimiza la experiencia del usuario y promueve el interés en disciplinas artísticas. Se recomienda realizar pruebas de usuario y mejoras continuas para asegurar la satisfacción del público objetivo.

## Diagrama de Arquitectura
![Arquitectura](https://github.com/user-attachments/assets/81dc50a8-f548-4c9d-914a-73c57b63b5d7)
La arquitectura de la aplicación móvil está organizada en módulos dentro de la carpeta `lib`, donde cada pantalla gestiona aspectos clave del evento, como el menú, eventos, ubicaciones, equipos y participantes. Además, hay módulos específicos para la coordinación de docentes y estudiantes. La aplicación también incluye servicios, como la autenticación y el archivo principal de inicio. Todo esto se conecta a varias APIs en la nube que gestionan la autenticación, eventos, ubicaciones, equipos y participantes, permitiendo una interacción fluida con datos externos.

## Diagrama de Componentes
![Componentes](https://github.com/user-attachments/assets/1fe9bc2e-0d0a-4d6f-9ac3-5229d9b50a7c)
El diagrama de componentes presenta la arquitectura de la aplicación móvil y su conexión con apis en la nube. La aplicación se divide en varios módulos, cada uno con una funcionalidad específica. El Módulo de Autenticación gestiona el acceso de usuarios a la aplicación, mientras que el Módulo de Eventos se encarga de la administración de los eventos de los Juegos Florales. El Módulo de Ubicaciones proporciona información sobre los lugares donde se llevarán a cabo los eventos, y el Módulo de Equipos facilita la gestión de los equipos participantes. Además, el Módulo de Participantes organiza a los participantes, y existen módulos dedicados a los Coordinadores Docentes y Estudiantes.

## Diagrama de Casos de uso
![Diagrama de casos de uso](https://github.com/user-attachments/assets/385cddbd-daae-4ce2-acfa-e2dc0aeefb66)
En este diagrama de casos de uso se pueden ver los requerimientos con los cumple la aplicación movil y con los que los usuarios van a poder observar y realizar dentro de la aplicación tales como iniciar sesión, visualizar informacion de los juegos florales, contactos, , eventos, participantes etc.

## Diagrama de Clases
![Topicos](https://github.com/user-attachments/assets/88af4503-31bd-4892-8454-27c6e5bb4a72)
En el diagrama de clases, definimos los campos que vamos a utilizar para el desarrollo de la aplicacion, considerando que cuatro clases son las que van vinculadas con las API'S y las otras dos son clases que contienen campos con valores estáticos.
