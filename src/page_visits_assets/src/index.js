import { page_visits } from "../../declarations/page_visits";

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  // Interact with page_visits actor, calling the greet method
  // const greeting = await page_visits.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
