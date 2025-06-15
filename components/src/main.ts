import { mount } from "svelte";
import "./main.css";
import "./layout.css";
import App from "./App.svelte";

const app = mount(App, {
  target: document.getElementById("com-app")!
});

export default app;
