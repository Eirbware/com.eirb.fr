import { mount } from "svelte";
import "./main.css";
import "./layout.css";
import App from "./App.svelte";

const comAppElement = document.getElementById("com-app");
if (comAppElement) {
  const botUsername =
    comAppElement.getAttribute("data-bot-username") ?? "<unknown>";
  const botLink = comAppElement.getAttribute("data-bot-link") ?? "about:blank";

  mount(App, {
    target: comAppElement,
    props: { botUsername, botLink },
  });
}
