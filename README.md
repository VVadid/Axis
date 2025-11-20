# Axis — 3D Character Controller & Melee Prototype

## Overview
Axis is a **technical prototype** built to practice and demonstrate a complete 3D character-controller and melee-combat pipeline in Godot.  
It is **not** a full game and does not aim to represent a specific genre.  
The purpose was to implement common gameplay systems in a clean, modular structure.

---

## Implemented Features

### Character Locomotion
Core movement mechanics designed to be responsive and modular:
- Walking and sprinting  
- Jumping and airborne logic  
- Directional evade/roll  
- Hierarchical state machine architecture

### Combat
Full melee system with animation-driven feedback:
- Melee attack system  
- Hitbox and hurtbox implementation  
- Custom resources for managing hit data and core combat stats (health, stamina)  
- **Stagger/Poise** system: stagger exceeding poise determines enemy pushback strength  
- Hitstop and camera shake effects  
- Basic knockback and stun handling  
- Animation-driven timing and responsiveness

### Camera & Targeting
Systems to support player control and enemy interaction:
- Third-person camera controller  
- Soft-lock targeting

### Enemies
Basic AI to demonstrate interaction with the combat system:
- Simple AI flow (idle → chase → attack)  
- Animation-based hit events  
- Basic damage, death, and feedback handling

---

## Not Implemented (By Design)
These systems were deliberately left out, as the prototype had already met its initial goals:
- Level design or progression  
- Finalized combat design or enemy variety  
- Full game structure (UI, inventory, quests, etc.)

---

## Reason for Archival
The prototype achieved its intended purpose:  
**learning and demonstrating a full 3D character controller, state logic, and melee interaction system in Godot.**

Extending it into a full game would require defining a clear genre and design direction, which was outside the scope of this project.

---

## What I Learned
- Built modular and scalable state machines for complex character actions  
- Implemented responsive melee combat with synchronized animations  
- Designed clear and maintainable AI behaviors  
- Integrated 3D movement, camera, and input systems effectively  
- Structured a Godot project for readability, iteration, and scalability

---

## Status
**Archived.**  
The repository remains public as a demonstration of Godot gameplay-system implementation.
