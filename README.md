# TaskFlow — iOS Task Management App
![iOS](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5-orange)
![UIKit](https://img.shields.io/badge/UIKit-Programmatic-black)
![Architecture](https://img.shields.io/badge/Architecture-VIPER%20%2B%20Clean-green)

A modern iOS Todo application built with a strong focus on clean architecture, scalability, and maintainability.

This project was originally created as a test assignment and later refined to demonstrate production-level engineering practices, architectural decisions, and code organization.

<img src="https://github.com/user-attachments/assets/d6aece3f-6d56-44d3-bc40-9c3a5b7ee45d" width="280"/>

## Features

* Display todo items in a list
* Create new tasks
* Edit existing tasks
* Delete tasks
* Splash & launch screens
* Initial data loading from network
* Offline persistence using Core Data
* Error handling and recovery
* Structured logging system
* Multiple build environments

## Tech Stack

* **Swift 5**
* **UIKit (programmatic UI)**
* **iOS 17+**
* **VIPER + Clean Architecture**
* **Dependency Injection with Swinject**
* **Moya** for networking
* **Core Data** for local persistence
* **Async/Await concurrency**
* **Environment-based configuration**

## Architecture

The project follows a modular layered architecture combining **VIPER** and **Clean Architecture** principles.

### Main Goals

* Separation of concerns
* High testability
* Scalable feature structure
* Clear dependency boundaries
* Maintainable business logic

### Layers

#### Core

Contains reusable shared components and cross-cutting concerns:

* Logging system
* Environment configuration
* Error handling
* Shared utilities
* Base abstractions and protocols

#### Data

Responsible for external and local data sources:

* Network layer (**Moya**)
* API models
* Repository implementations
* Core Data persistence
* DTO mapping

#### Presentation

Contains UI and feature modules:

* VIPER modules
* Presenters
* Interactors
* Routers
* Views
* UI state handling

#### App

Application entry point and composition root:

* Dependency registration
* Environment setup
* App lifecycle configuration

#### Resources

Application assets and configuration files.

## Project Structure

```text
TodoApp
├── App
├── Core
├── Data
├── Presentation
└── Resources
```

## Networking & Persistence

On first launch, the application loads todo data from a remote source and stores it locally using **Core Data**.

This approach provides:

* Fast subsequent launches
* Offline support
* Data persistence between sessions

## Error Handling

The application includes centralized error handling with proper user feedback and logging.

Handled scenarios include:

* Network failures
* Data loading issues
* Persistence errors
* Unexpected application states

## Logging

A structured logging system is implemented to simplify debugging and feature tracking.

Logging categories include:

* UI events
* Feature flow
* Network requests
* Data operations
* Errors

## Environments

The project supports multiple environments:

* **Mock**
* **Development**
* **Staging**
* **Release**

This allows easy testing and configuration switching during development.

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/b5cbd8f3-0dc3-41e2-a9f5-af15f017a7a9" width="280"/>
  <img src="https://github.com/user-attachments/assets/6734a9ef-ec9e-4b9c-b3a7-1434f6d94fdb" width="280"/>
  <img src="https://github.com/user-attachments/assets/77a1cc43-8940-4fb1-af21-59933ad17d93" width="280"/>
</p>

## Requirements

* **iOS 17.0+**
* **Xcode 26**
* **Swift 5**

## Installation

1. Clone the repository

```bash
git clone https://github.com/nikolai-eremenko/TaskFlow
```

2. Open the project in Xcode

```bash
open todo.xcodeproj
```

3. Build and run the application.

## Engineering Focus

This project emphasizes:

* Clean code principles
* Architecture consistency
* SOLID principles
* Dependency injection
* Scalable project structure
* Maintainable UIKit codebase
* Explicit error management
* Production-style logging

---

This repository serves as an example of my iOS engineering approach, architectural decisions, and code organization practices.
