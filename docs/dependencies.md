# Swift Package Dependency Graph

This document provides visualizers for the Swift package dependencies in the RetroShell repository.

## 1. Layered Architecture View

This view groups packages by their role (Implementations, Core, External), making it easier to see the architectural strata.

```mermaid
graph TD
    subgraph Platforms ["Platform Implementations"]
        direction LR
        RetroApple
        RetroAtari
        RetroCommodore
        RetroMicrosoft
        RetroSinclair
        RetroTandy
    end

    subgraph Core ["Core Framework"]
        direction LR
        RetroCore
        FileSystemKit
    end

    subgraph External ["External / Third Party"]
        direction LR
        StandardFileSystem
        DesignAlgorithmsKit
        InventoryKit
        swift-docc-plugin
    end

    %% Internal Dependencies
    RetroApple & RetroAtari & RetroCommodore & RetroMicrosoft & RetroSinclair & RetroTandy --> RetroCore
    RetroApple & RetroAtari & RetroCommodore & RetroMicrosoft & RetroSinclair & RetroTandy --> FileSystemKit
    RetroCore --> FileSystemKit

    %% External Dependencies
    RetroApple & RetroAtari & RetroCommodore & RetroMicrosoft & RetroSinclair & RetroTandy --> StandardFileSystem
    RetroCore --> StandardFileSystem
    RetroCore --> DesignAlgorithmsKit
    RetroCore --> InventoryKit
    FileSystemKit --> DesignAlgorithmsKit
    FileSystemKit --> swift-docc-plugin
```

## 2. Dependency Network (Force Directed)

The strict dependency graph, useful for tracing specific import paths.

```mermaid
graph LR
    %% Submodule packages
    RetroApple --> FileSystemKit
    RetroApple --> RetroCore
    RetroApple --> StandardFileSystem

    RetroAtari --> FileSystemKit
    RetroAtari --> RetroCore
    RetroAtari --> StandardFileSystem

    RetroCommodore --> FileSystemKit
    RetroCommodore --> RetroCore
    RetroCommodore --> StandardFileSystem

    RetroMicrosoft --> FileSystemKit
    RetroMicrosoft --> RetroCore
    RetroMicrosoft --> StandardFileSystem

    RetroSinclair --> FileSystemKit
    RetroSinclair --> RetroCore
    RetroSinclair --> StandardFileSystem

    RetroTandy --> FileSystemKit
    RetroTandy --> RetroCore
    RetroTandy --> StandardFileSystem

    RetroCore --> FileSystemKit
    RetroCore --> StandardFileSystem
    RetroCore --> DesignAlgorithmsKit
    RetroCore --> InventoryKit

    FileSystemKit --> DesignAlgorithmsKit
    FileSystemKit --> swift-docc-plugin
```

## 3. Class Diagram Association View

An alternative view using UML notation, which can be cleaner for dense graphs.

```mermaid
classDiagram
    direction RL
    class RetroCore
    class FileSystemKit
    class RetroApple
    class RetroAtari
    class RetroCommodore
    class RetroMicrosoft
    class RetroSinclair
    class RetroTandy
    
    %% External
    class StandardFileSystem {
        <<external>>
    }
    class DesignAlgorithmsKit {
        <<external>>
    }
    class InventoryKit {
        <<external>>
    }

    %% Relationships
    RetroApple ..> RetroCore
    RetroApple ..> FileSystemKit
    RetroApple ..> StandardFileSystem
    
    RetroAtari ..> RetroCore
    RetroAtari ..> FileSystemKit
    RetroAtari ..> StandardFileSystem

    RetroCommodore ..> RetroCore
    RetroCommodore ..> FileSystemKit
    RetroCommodore ..> StandardFileSystem
    
    RetroMicrosoft ..> RetroCore
    RetroMicrosoft ..> FileSystemKit
    RetroMicrosoft ..> StandardFileSystem
    
    RetroSinclair ..> RetroCore
    RetroSinclair ..> FileSystemKit
    RetroSinclair ..> StandardFileSystem

    RetroTandy ..> RetroCore
    RetroTandy ..> FileSystemKit
    RetroTandy ..> StandardFileSystem

    RetroCore ..> FileSystemKit
    RetroCore ..> StandardFileSystem
    RetroCore ..> DesignAlgorithmsKit
    RetroCore ..> InventoryKit
    
    FileSystemKit ..> DesignAlgorithmsKit
```

## Insights

- **FileSystemKit** is the foundational dependency used by almost everything.
- **RetroCore** serves as the shared logic layer for all platform implementations.
- **StandardFileSystem** acts as a bridge for standard FS operations across platforms.
