# Dataflow Architecture

Helios2400 uses a entity-component-system architecture, with significant use of a message bus.

## Registry

The Registry is concerned with the actual 'data' of a game: the stuff you would store in a database of values. This includes things like what art asset a terrain tile uses, the attack rating of an army, the health of a unit, the position of a planet, and so on. Helios2400 utilizes entities (GameObjects) made up of components to organize the data:

- **Datatypes** are the smallest organizational unit, and include things like arrays of numbers, polygons, coordinate tuples, and other raw data
- **Components** are made up of datatypes, and are the principal objects of manipulation used by game systems. Components group datatypes together towards asemantic purpose: a 'Renderable' component, for example, groups a picture dataype and a position datatype to enable drawing a picture to screen.
- **Game Objects** are simply a bundle of components all associated to the same unique identifier (UID). Game Objects represent semantic elements in the game, such as a clickable unit or a button in the UI

All game data lives in components stored in the **Registry**, which is a dictionary of Game Objects referenced by their UID. The Registry can be thought of as a 2-d matrix of components, with components in the same column being members of the same game object, and components in the same row being members of the same 'component pool'.

## Systems

Helios2400 has several systems, each responsible for a subset of the Registry. Systems are the 'functions' of the game, and typically are called once every tick/frame of the game. Systems have an anatomy of their own:

- Each system has one or more **Structures**, which define both *which* components/GameObjects in the registry the system operates on and *how* they are related to each other. In some systems this is a simple list, but other systems might maintain a map or a scenegraph built up of UIDs
- Systems have **External Functions**, which basically just tell the system to perform its task. This might be a `draw`, `update`, or some similar on-demand function.
- Systems each have **Specified Pools**. Systems state what components an object must have in order for the structure to be able to operate on the game object.

**It is important to REFRAIN FROM STORING PERSISTENT DATA IN SYSTEM STRUCTURES**. Although a cache within the system is acceptable if needed, systems should try to restrict themselves as much as possible to only storing references to objects in the Registry, rather than copy them. Conceptually, a system should be able (in principle) to be generated every frame of the game, at least in its design. This is to discourage keeping game state outside of the registry (which would complicate determinism of the game engine).

