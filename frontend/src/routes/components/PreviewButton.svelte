<script lang="ts">
  import { onMount } from "svelte";
  import { preview } from "./runes/preview.svelte";

  function changeDefaultPreview(isScreenMobileOrPortrait: boolean) {
    preview.state = !isScreenMobileOrPortrait;
  }
  function togglePreview() {
    preview.state = !preview.state;
  }

  onMount(() => {
    const mediaQuery = "(max-width: 480px), screen and (orientation: portrait)";
    const mql = window.matchMedia(mediaQuery);
    const screenLayoutChangeListener = (event: MediaQueryListEvent) =>
      changeDefaultPreview(event.matches);
    mql.addEventListener("change", screenLayoutChangeListener);
    return () => {
      mql.removeEventListener("change", screenLayoutChangeListener);
    };
  });
</script>

<button class="preview-button" id="preview-button" on:click={togglePreview}>
  {#if !preview.state}
    <img
      alt="preview"
      class="preview-button--preview"
      id="preview-button--preview"
      src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjRweCIgdmlld0JveD0iMCAtOTYwIDk2MCA5NjAiIHdpZHRoPSIyNHB4IiBmaWxsPSIjNWY2MzY4Ij48cGF0aCBkPSJNMjAwLTEyMHEtMzMgMC01Ni41LTIzLjVUMTIwLTIwMHYtNTYwcTAtMzMgMjMuNS01Ni41VDIwMC04NDBoNTYwcTMzIDAgNTYuNSAyMy41VDg0MC03NjB2NTYwcTAgMzMtMjMuNSA1Ni41VDc2MC0xMjBIMjAwWm0wLTgwaDU2MHYtNDgwSDIwMHY0ODBabTI4MC04MHEtODIgMC0xNDYuNS00NC41VDI0MC00NDBxMjktNzEgOTMuNS0xMTUuNVQ0ODAtNjAwcTgyIDAgMTQ2LjUgNDQuNVQ3MjAtNDQwcS0yOSA3MS05My41IDExNS41VDQ4MC0yODBabTAtNjBxNTYgMCAxMDItMjYuNXQ3Mi03My41cS0yNi00Ny03Mi03My41VDQ4MC01NDBxLTU2IDAtMTAyIDI2LjVUMzA2LTQ0MHEyNiA0NyA3MiA3My41VDQ4MC0zNDBabTAtMTAwWm0wIDYwcTI1IDAgNDIuNS0xNy41VDU0MC00NDBxMC0yNS0xNy41LTQyLjVUNDgwLTUwMHEtMjUgMC00Mi41IDE3LjVUNDIwLTQ0MHEwIDI1IDE3LjUgNDIuNVQ0ODAtMzgwWiIvPjwvc3ZnPg=="
    />
  {:else}
    <img
      alt="nopreview"
      class="preview-button--nopreview"
      id="preview-button--nopreview"
      src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjRweCIgdmlld0JveD0iMCAtOTYwIDk2MCA5NjAiIHdpZHRoPSIyNHB4IiBmaWxsPSIjNWY2MzY4Ij48cGF0aCBkPSJNNDgwLTI4MHEtODIgMC0xNDYuNS00NC41VDI0MC00NDBxMjAtNDggNTYtODR0ODQtNTZsNDcgNDdxLTM5IDExLTcwIDM0LjVUMzA2LTQ0MHEyNiA0NyA3MiA3My41VDQ4MC0zNDBxMzAgMCA1OC04dDUxLTIzbDQzIDQzcS0zMiAyMy03MC41IDM1LjVUNDgwLTI4MFptMjA5LTEwNC00My00M3EyLTMgNC02LjV0NC02LjVxLTE4LTMzLTQ3LTU2LjVUNTQyLTUzMWwtNjktNjlxODIgMCAxNTAgNDQuNVQ3MjAtNDQwcS02IDE1LTEzLjUgMjlUNjg5LTM4NFpNNzkxLTU2bC02NC02NEgyMDBxLTMzIDAtNTYuNS0yMy41VDEyMC0yMDB2LTUyN2wtNjQtNjUgNTYtNTYgNzM2IDczNi01NyA1NlpNMjAwLTIwMGg0NDdMMjAwLTY0N3Y0NDdabTY0MC0zMy04MC04MHYtMzI3SDQzM0wyMzMtODQwaDUyN3EzMyAwIDU2LjUgMjMuNVQ4NDAtNzYwdjUyN1oiLz48L3N2Zz4="
    />
  {/if}
</button>

<style>
  .preview-button {
    display: none;
  }

  @media (max: 480px), screen and (orientation: portrait) {
    .preview-button {
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 100%;
      background-color: #f3c420;

      position: fixed;
      bottom: calc(10dvh + 2rem);
      right: 2rem;

      padding: 0.75rem;
    }

    .preview-button--preview,
    .preview-button--nopreview {
      width: 2rem;
      aspect-ratio: 1 / 1;
    }
  }
</style>
