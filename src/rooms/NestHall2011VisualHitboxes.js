export const NEST_HALL_2011_VISUAL_HITBOXES = Object.freeze({
  1: Object.freeze({ x: 20, y: 120, width: 85, height: 125, label: "door 1" }),
  2: Object.freeze({ x: 525, y: 135, width: 70, height: 130, label: "door 2" }),
  3: Object.freeze({ x: 275, y: 150, width: 58, height: 95, label: "door 3" }),
  4: Object.freeze({ x: 278, y: 303, width: 75, height: 44, label: "door 4" }),
  5: Object.freeze({ x: 108, y: 145, width: 75, height: 155, label: "door 5" }),
  6: Object.freeze({ x: 455, y: 160, width: 65, height: 110, label: "door 6" }),
  7: Object.freeze({ x: 135, y: 318, width: 82, height: 36, label: "door 7" }),
  8: Object.freeze({ x: 395, y: 318, width: 82, height: 36, label: "door 8" }),
  9: Object.freeze({ x: 45, y: 8, width: 150, height: 90, label: "garden" }),
  10: Object.freeze({ x: 480, y: 285, width: 125, height: 75, label: "home cinema" })
});

export function getNestHall2011VisualHitbox(doorId) {
  return NEST_HALL_2011_VISUAL_HITBOXES[doorId] || null;
}
