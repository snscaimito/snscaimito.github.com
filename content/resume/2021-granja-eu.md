## **Client**: Caimito Agile Life  
**Location**: Andalusia, Spain  
**Duration**: 2021 - 2023  

---

### **Objective**:  
Develop an ecosystem of applications to support an **Andalusian restoration project** by enabling:  
1. A frontend platform (**CaimitoEU**) for promoting packaged products and fresh Iberico meat.  
2. A backend system (**GranjaEU**) serving as a small-scale ERP for daily farm operations.

---

### **Solution**:

#### **CaimitoEU - Frontend Platform**  
- **Frontend Development**:  
   - Built using **JavaScript (Vue.js 3)** with clean **HTML5/CSS3** styling.  
   - Styling was redone entirely in **pure CSS3** after a failed experience with TailwindCSS.  
- **Multi-Language Support**:  
   - Implemented using **vue-i18n** with Vue Router tricks for language-specific content.  
   - Languages supported: **English, German, and Spanish**.  
- **API Integration**:  
   - Consumes secured REST endpoints from the **GranjaEU backend**.  
   - Uses **Keycloak** for OAuth2-based authentication with service accounts.  
- **Payment Integration**:  
   - Integrated **PayPal** for processing payments seamlessly.  
- **Deployment**:  
   - Packaged as a **Docker container** with an **NGINX reverse proxy** for SSL encryption.  
   - Build and deploy managed via **GitHub Actions** multi-stage pipelines, running:  
      - **Cypress UI tests** and **smoke tests** before production readiness.  
   - Supports **feature flags** to test complex features in staging before production.

---

#### **GranjaEU - Backend and ERP System**  
- **Backend Development**:  
   - Built with **Java (Spring Boot)** exposing secured **REST APIs** for the CaimitoEU platform and future applications.  
   - Integrates user management via **Keycloak** for OAuth2-based security.  
- **Data Management**:  
   - Structured data stored in **PostgreSQL**; documents stored in **MongoDB**.  
   - **Flyway** used for database migrations.  
- **ERP Features**:  
   - Supports farm workers for daily operations with a **Vuetify-based UI**.  
   - Provides email notifications to customers via **JavaMail** and **Google SMTP**.  
   - UI supports **English and Spanish**.  
- **Testing and Deployment**:  
   - **Test-Driven Development** and **Rapid Prototyping** with real farm worker feedback.  
   - Built with **Maven**, running extensive **JUnit tests** (unit and integration).  
   - **Cypress** tests for UI and smoke testing critical functionality.  
   - Packaged into Docker containers, stored in **GitHub Container Registry**, and deployed via **SSH to Docker Compose**.  
- **Server Maintenance**:  
   - All servers running **Docker Engine on Debian Linux** were maintained directly.

---

### **Outcome**:  
- Delivered a seamless, integrated ecosystem enabling product promotion, online sales, and farm management.  
- Achieved **multiple deployments per day** using trunk-based development, ensuring rapid delivery of new features and fixes.  
- Improved collaboration between developers and farm workers by incorporating early feedback.  
- Enhanced scalability and maintainability of the infrastructure with Docker and automation pipelines.

---

### **Technologies Used**:

- **Frontend**: JavaScript, Vue.js 3, CSS3, Vue Router, vue-i18n  
- **Backend**: Java (Spring Boot: REST, Data, Mail, Thymeleaf, Security), Flyway  
- **Testing**: Cypress, JUnit  
- **Authentication**: Keycloak (OAuth2)  
- **Data Storage**: PostgreSQL, MongoDB  
- **Containerization**: Docker, Docker Compose  
- **CI/CD**: GitHub Actions  
- **Web Server**: NGINX  
- **Email**: JavaMail with Google SMTP  
- **Tools**: Maven, SSH

---

### **Key Contributions**:  
- Architected the integration between **CaimitoEU** and **GranjaEU** for seamless operation.  
- Developed a lightweight, secure frontend with **Vue.js** and API-backed data.  
- Implemented robust backend APIs with **Spring Boot** and secure authentication via **Keycloak**.  
- Streamlined deployments with CI/CD pipelines and automated testing.  
- Maintained and optimized Docker-based production servers.

