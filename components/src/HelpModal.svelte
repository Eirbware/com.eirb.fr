<script lang="ts">
  import { displayHelpModal } from "./runes/display-help-modal.svelte";
</script>

<!-- Help Modal -->
{#if displayHelpModal.state}
  <dialog class="help-modal" id="help-modal">
    <div class="help-modal--back" id="help-modal--back"></div>

    <div class="help-modal--container">
      <div class="help-modal--header">
        <h3>Comment trouver mon chat id ?</h3>

        <button class="help-modal--close" id="help-modal--close">
          <img
            alt="close"
            class="help-modal--close-img"
            src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTE5LDYuNDFMMTcuNTksNUwxMiwxMC41OUw2LjQxLDVMNSw2LjQxTDEwLjU5LDEyTDUsMTcuNTlMNi40MSwxOUwxMiwxMy40MUwxNy41OSwxOUwxOSwxNy41OUwxMy40MSwxMkwxOSw2LjQxWiIgLz48L3N2Zz4="
          />
        </button>
      </div>

      <hr class="help-modal--separator" />

      <div class="help-modal--body">
        <ol>
          <!-- TODO: complete with the credentials of the Bot -->
          <li>
            Contactez
            <a target="_blank" href="t.me/Occulteirbot">Occulteirbot</a>
          </li>
          <li>Envoyez-lui la commande <code>/start</code></li>
          <li>Vous recevrez votre chat id en réponse en ce sera bon !</li>
        </ol>
      </div>
    </div>
  </dialog>
{/if}

<!-- End Help Modal -->

<style>
  dialog {
    position: fixed;
    left: 0;
    top: 0;

    width: 100vw;
    height: 100vh;
  }

  .help-modal--back {

    background-color: #2d2d2d40;
  }

  .help-modal--container {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    display: flex;
    flex-direction: column;
    align-items: center;

    border-radius: 0.25rem;
    padding: 1rem 2rem;
    max-width: 90vw;

    background-color: #fff;
  }

  .help-modal--separator {
    width: 75%;
  }

  .help-modal--header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    gap: 3rem;
    padding: 1rem 0;
  }

  .help-modal--body {
    display: flex;
    flex-direction: column;
    padding: 1rem;
    width: 100%;
  }

  .help-modal--close {
    padding: 1rem;
    border: none;
    background-color: transparent;
  }

  .help-modal--close-img {
    width: 2rem;
    cursor: pointer;
  }
</style>
