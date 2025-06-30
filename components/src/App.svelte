<script lang="ts">
  import PlatformSelector from "./PlatformSelector.svelte";
  import PromptConsole from "./PromptConsole.svelte";
  import Renderer from "./renderer";
  import HelpModal from "./HelpModal.svelte";
  import PreviewButton from "./PreviewButton.svelte";
  import { preview } from "./runes/preview.svelte";

  export let botUsername: string = "";
  export let botLink: string = "";
</script>

<!-- Left half of the screen with a form -->
<header><PlatformSelector></PlatformSelector></header>
<main><PromptConsole {botUsername} {botLink}></PromptConsole></main>

<!-- Right half of the screen -->
{#if preview.state}
  <aside><Renderer></Renderer></aside>
{/if}
<!-- Button and modal -->
<PreviewButton></PreviewButton>
<HelpModal></HelpModal>

<style>
  :global(#com-app) {
    height: 100dvh;
    width: 100vw;
    display: grid;
    grid-template-areas:
      "header preview"
      "editor preview";

    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 9fr;
  }

  main {
    width: 100%;
    display: flex;
    flex-direction: row;
    grid-area: editor;
  }

  header {
    grid-area: header;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: serif;
    font-optical-sizing: auto;
    font-style: normal;
    text-align: center;
    padding: 0.5rem;
  }

  aside {
    grid-area: preview;
    padding: 30px;
    background-color: #f5f5f5;
    border: 1px solid #ccc;
    overflow-y: auto;
  }

  @media (max: 480px), screen and (orientation: portrait) {
    :global(#com-app) {
      grid-template-areas:
        "header header"
        "editor editor";
    }
    aside {
      display: block;
      position: fixed;
      left: 0;
      top: 0;
      width: 100vw;
      height: 100dvh;
    }
  }
</style>
