# SAP RAP: Taxi Booking & Dispatch System (Project 083)

A modern, full-stack enterprise application built using the **ABAP RESTful Application Programming Model (RAP)**.
This project facilitates the management of **taxi drivers and passenger bookings**, featuring a **Draft-enabled workflow** and an **OData V4 service interface**.

---

# 🚕 Project Overview

The **ZCIT_RAP_TAXI_083** project provides a comprehensive solution for **taxi fleet management**.

It manages the complete lifecycle of a taxi booking:

1. Passenger creates a booking
2. System assigns a driver
3. Driver accepts the trip
4. Trip gets completed or cancelled

The system uses the **RAP Draft Framework** to maintain **data consistency and allow stateful editing** before final submission.

---

# 🚀 Key Features

### OData V4 Integration

Uses the **latest OData protocol** for modern API communication and improved performance.

### Draft Capability

Supports **Save as Draft**, allowing users to:

* Pause booking creation
* Resume later
* Avoid validation errors before final submission

### Driver & Booking Management

The system follows a **dual-entity model**:

* **Driver Entity (Master Data)**
* **Booking Entity (Transactional Data)**

### Automated Data Seeding

Includes a **utility class**:

```
ZCL_FILL_TAXI_DATA_083
```

This class automatically generates **sample taxi drivers and booking records** for testing.

### Stateful Validations

The system performs **real-time validations** during draft editing to ensure accurate data entry.

---

# 🛠 Technical Stack

| Component        | Technology                         |
| ---------------- | ---------------------------------- |
| Framework        | ABAP RAP                           |
| Implementation   | Managed / Unmanaged with Draft     |
| Service Protocol | OData V4                           |
| Service Binding  | `ZUI_TAXI_083_O4`                  |
| Database         | SAP HANA                           |
| Tables           | `ZTAXI_BOOK_083`, `ZTAXI_DRIV_083` |
| UI Framework     | SAP Fiori Elements                 |
| UI Type          | List Report + Object Page          |

---

# 📁 Project Structure

Based on the **ZCIT_RAP_TAXI_083 package**.

---

# 1️⃣ Business Services

### Service Definition

```
ZUI_TAXI_083
```

Exposes the **Taxi Driver and Booking entities**.

### Service Binding

```
ZUI_TAX_083_O4
```

Provides the **OData V4 endpoint** used by the **SAP Fiori UI**.

---

# 2️⃣ Dictionary (Database Tables)

### Driver Table

```
ZTAXI_DRIV_083
```

Stores **driver master data**.

Draft Table:

```
ZTAXI_DRIV_083_D
```

Used for **draft editing of driver records**.

---

### Booking Table

```
ZTAXI_BOOK_083
```

Stores **passenger booking transactions**.

Draft Table:

```
ZTAXI_BOOK_083_D
```

Used for **draft booking editing**.

---

# 3️⃣ Core Data Services (CDS)

The project contains **multiple CDS objects** including:

* Root View Entities
* Projection Views
* Metadata Extensions

These define:

* Data modeling
* UI structure
* Business object exposure

Example entities include:

```
ZI_TAXI_DRIVER_083
ZI_TAXI_BOOKING_083
ZC_TAXI_DRIVER_083
ZC_TAXI_BOOKING_083
```

Metadata extensions control:

* UI layout
* Field grouping
* Search filters

---

# 4️⃣ Source Code Library

### Behavior Pool Class

```
ZBP_I_TAXIBOOKING_083
```

This class contains the **business logic** including:

* Validations
* Determinations
* Custom Actions

---

### Data Generator Class

```
ZCL_FILL_TAXI_DATA_083
```

Used to **populate initial test data** for drivers and bookings.

---

# ⚙️ Setup & Installation

### Step 1 – Create Database Tables

Activate the dictionary tables:

```
ZTAXI_DRIV_083
ZTAXI_BOOK_083
```

---

### Step 2 – Generate Test Data

Execute the class:

```
ZCL_FILL_TAXI_DATA_083
```

Run using **F9 in ABAP Development Tools (ADT)**.

This will automatically create:

* Sample drivers
* Sample bookings

---

### Step 3 – Activate Behavior Definition

Activate the **Behavior Definition** to enable:

* Draft handling
* CRUD operations
* Business logic execution

---

### Step 4 – Publish Service

Activate the **Service Binding**:

```
ZUI_TAX_083_O4
```

This publishes the **OData V4 service**.

---

### Step 5 – Launch UI Application

1. Open **Service Binding**
2. Right-click the **Entity**
3. Select **Preview**

The **SAP Fiori Elements application** will open.

---

# 🔑 Key Logic Components

### Determinations

Used for **automatic field updates**, such as:

* Booking price calculation
* Driver availability status

---

### Actions

Custom buttons in the UI allow:

* **Accept Booking**
* **Cancel Booking**
* **Complete Trip**

---

### Validations

Ensures data consistency by checking:

* Driver availability
* Passenger details
* Duplicate bookings

---

# 📊 Application Workflow

1. User creates a taxi booking
2. Booking is saved as **Draft**
3. System validates booking details
4. Driver is assigned
5. Driver accepts trip
6. Trip is completed or cancelled

---

# 🎯 Learning Outcomes

This project demonstrates:

* **SAP RAP Draft Handling**
* **OData V4 service exposure**
* **Fiori Elements application development**
* **Master-Transaction data modeling**
* **Custom RAP actions and validations**

---

# 👨‍💻 Author

**Kowsick K**

Project: **Taxi Booking System (083)**
Package: **ZCIT_RAP_TAXI_083**
Technology: **SAP RAP + OData V4 + Draft Handling**
Date: **March 2026**



These make recruiters immediately understand your project.
