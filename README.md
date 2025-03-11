# Game of Life & Forest Fire Simulation

## Overview
This repository contains two cellular automaton-based simulations: 
1. **Game of Life** - An implementation of Conway's Game of Life, simulating the evolution of cells based on predefined rules.
2. **Forest Fire Simulation** - A probabilistic simulation modeling the spread of wildfires, tree growth, and environmental factors such as drought and wind.

Both simulations are implemented in **Processing (Java-based language)** and utilize a grid-based approach for state transitions. The **Forest Fire Simulation builds upon the logic of Conway's Game of Life**, adapting the core mechanics to simulate fire spread and environmental interactions.

---

## Game of Life

### Implementation Details
- **Grid Representation**: The world is represented as a 2D integer array (`board[][]`), where `1` denotes a live cell and `0` denotes a dead cell.
- **Initialization**: The board is randomly populated with live and dead cells.
- **Rendering**: Each cell is drawn as a rectangle on the canvas, where alive cells are white and dead cells are black.
- **Rules & Transitions**: Each cell’s state is updated based on the number of live neighbors using Conway’s rules:
  - A live cell survives if it has **2 or 3** live neighbors; otherwise, it dies.
  - A dead cell becomes alive if it has exactly **3** live neighbors.
- **Optimizations**:
  - The next state is stored in a temporary buffer (`tempBoard[][]`) to avoid modifying the current state mid-update.
  - Board updates use modular arithmetic for edge wrapping.
  - Mouse input allows direct interaction: dragging creates new live cells.

---

## Demo
![gameOfLife Demo](https://raw.githubusercontent.com/Matthew8747/GoL-FFsim/tree/main/assets/goldemo.gif)

## Forest Fire Simulation

### Implementation Details
- **Grid Representation**: The environment is stored in a 2D integer array (`board[][]`), where each cell can be:
  - `0` - Empty land
  - `1` - Young tree
  - `2` - Mature tree
  - `3` - Burning tree
  - `4` - Recently burned area
  - `5` - Ash (burned-out land)
  - `6` - Water (prevents fire spread)
- **State Transitions**:
  - Trees grow probabilistically.
  - Fire spreads based on neighboring burning cells, adjusted by **wind direction** and **drought conditions**.
  - Burned areas regenerate over time.
  - Water cells influence nearby tree growth probability.
- **Environmental Factors**:
  - **Drought Mode**: Introduces a multiplier (`2.5x`) that increases fire spread probability.
  - **Wind**: Fire spreads faster in the wind’s direction (`windStrength` modifier applied to adjacent cells).
- **Mouse Interaction**:
  - Clicking ignites a fire in a selected cell.
  - Dragging the mouse burns a larger area dynamically.

### Connection to Game of Life
The **Forest Fire Simulation extends the principles of the Game of Life** by replacing the binary live/dead cell states with multiple states representing trees, fire, and regrowth. The update mechanism follows similar neighborhood-based rules but incorporates probabilities and environmental factors to model realistic fire behavior.

## Demo
![ForestFireSim Demo](https://raw.githubusercontent.com/Matthew8747/GoL-FFsim/tree/main/assets/ffsdemo.gif)

---

## Running the Simulations
- Requires **Processing (3.x or 4.x)**.
- Open the respective `.pde` file in the Processing IDE and run the sketch.
- Adjust parameters at the top of the script to tweak probabilities and behaviors.

