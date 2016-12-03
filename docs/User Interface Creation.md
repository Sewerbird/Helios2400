# User Interface Creation

This article details how to implement a proper portion of the UI.

## Checklist

- [ ] Create a class file in `src/ui`
- [ ] Pass the Registry to the UIObject you are implementing
- [ ] Add childen UIObjects in the Registry as necessary
- [ ] Attach the UIObjects to each other and ultimately to the root UIObject
- [ ] Bind the UIObjects to StateObjects as necessary
- [ ] Define things like TouchDelegates
- [ ] Return the root UIObject, to be inserted into the SceneGraph
- [ ] Instantiate the class where appropriate

## Overview

![Architecture](https://github.com/Sewerbird/Helios2400/blob/master/docs/ui_architecture.png)

First, it's important to know how UI elements are organized, with respect to the GameObjects and GameSystems they interact with.