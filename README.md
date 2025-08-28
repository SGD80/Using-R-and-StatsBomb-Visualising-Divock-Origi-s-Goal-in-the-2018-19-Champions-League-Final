# ⚽ StatsBomb Shot Freeze Frame Visualisation (Champions League Final 2018/19)

This R project leverages the `StatsBombR` package to extract shot data from the 2018/19 Champions League Final and visualizes one of the key shots (e.g., Divock Origi’s goal) using freeze frame data. The script processes shot-level information and illustrates teammates’ and opponents’ positions on the pitch at the moment of the shot.

---

## 📌 Features

- ✅ Accesses **free StatsBomb match and event data** via `StatsBombR`
- ✅ Filters **shot events** and extracts freeze frame details
- ✅ Cleans and reshapes freeze frame data for plotting
- ✅ Builds a **custom ggplot2 football pitch**
- ✅ Overlays:
  - Shot trajectory
  - Shooter and teammate positions
  - Player names and outcomes (e.g., goal)
- ✅ Creates a **visual storytelling graphic** from raw match data

---

## 🛠️ How It Works

Step 1: Load Match & Event Data

Filters and loads match data for the 2018/19 UEFA Champions League Final using StatsBombR.

Step 2: Extract Shot Events

Focuses on shot events and assigns unique identifiers to each shot.

Step 3: Unnest Freeze Frame Data

Parses each player's position during the shot, capturing:

X and Y coordinates

Player name

Whether they are teammates

Step 4: Plotting

Uses ggplot2 to:

Draw a detailed football pitch

Overlay players involved in a specific shot

Highlight:

The shooter

Teammates

Shot outcome (e.g., goal)

Direction of the shot

## 🖼️ Example Output

A visual freeze frame of a shot attempt, including:

Shooter's name

Teammate positions (colored distinctly)

Shot direction with an arrow

Full football pitch layout

This example focuses on a shot by Divock Origi in the Champions League Final, 2019.

## 📚 Data Source

StatsBomb Open Data

Match: 2018/19 UEFA Champions League Final

Competition ID: 16 (Champions League)

Season ID: 4 (2018/19)

## 📜 License

This project is for educational and research purposes only, using publicly available open data from StatsBomb.
All code is released under the MIT License
.

## 👤 Author

Scott Dunn
R Programmer | Sports Analytics Enthusiast | Football Data Visualiser
📫 LinkedIn - https://www.linkedin.com/in/scott-dunn-a5936b23/