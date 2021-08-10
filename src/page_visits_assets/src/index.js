import { page_visits } from "../../declarations/page_visits";

const deviceType =
  /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
    navigator.userAgent
  )
    ? { Mobile: null }
    : { Desktop: null };

page_visits.log(location.href, deviceType).then(async (response) => {
  console.log(response);
  updatePage();
});

async function updatePage() {
  const currentCount = await page_visits.getSummary(location.href);
  console.log(currentCount);
  document.querySelector("#total").innerText = currentCount.ok?.total;
  document.querySelector("#mobile").innerText = currentCount.ok?.mobile;
  document.querySelector("#desktop").innerText = currentCount.ok?.desktop;
}
updatePage();

page_visits.getLogs().then((logs) => {
  console.log(logs);
});
