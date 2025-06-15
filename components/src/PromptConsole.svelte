<script>
  import { displayHelpModal } from "./runes/display-help-modal.svelte";

  function openHelp() {
    displayHelpModal.state = true;
  }
</script>

<form id="dataForm" action="#" method="POST" class="editor">
  <!-- Main markdown input div taking 90% of the height -->
  <div class="input-container">
    <!-- TODO: add the placeholders as slugs -->
    <textarea id="message" name="message" placeholder="Enter your message here"
      >Enter your message here</textarea
    >
  </div>

  <!-- Chat id input and submit button occupying the remaining 10% of
          the height -->
  <div class="input-row">
    <input
      id="chat-id"
      type="text"
      placeholder="Enter your chat id"
      name="chat_id"
    />

    <!-- noform to prevent the button from triggering the form submit event -->
    <button
      form="noform"
      on:click={openHelp}
      id="help-button"
      title="Où trouver le chat-id ?"
    >
      <img
        src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxZW0iIGhlaWdodD0iMWVtIiB2aWV3Qm94PSIwIDAgMjQgMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTEwIDE5aDN2M2gtM3ptMi0xN2M1LjM1LjIyIDcuNjggNS42MiA0LjUgOS42N2MtLjgzIDEtMi4xNyAxLjY2LTIuODMgMi41QzEzIDE1IDEzIDE2IDEzIDE3aC0zYzAtMS42NyAwLTMuMDguNjctNC4wOGMuNjYtMSAyLTEuNTkgMi44My0yLjI1QzE1LjkyIDguNDMgMTUuMzIgNS4yNiAxMiA1YTMgMyAwIDAgMC0zIDNINmE2IDYgMCAwIDEgNi02Ii8+PC9zdmc+"
        alt="help"
      />
    </button>

    <button type="submit" id="submit-button">
      <img
        src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxZW0iIGhlaWdodD0iMWVtIiB2aWV3Qm94PSIwIDAgMjQgMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0ibTIgMjFsMjEtOUwyIDN2N2wxNSAybC0xNSAyeiIvPjwvc3ZnPg=="
        alt="submit"
      />
    </button>
  </div>
</form>

<style>
  .editor {
    display: flex;
    height: 100%;
    width: 100%;
    flex-direction: column;
    justify-content: space-between;

    font-family: "Fira Mono", monospace;
    font-weight: 400;
    font-style: normal;
  }

  .input-container {
    height: 90%;
    border: 1px solid #ccc;
    padding: 10px;
    /* You can add padding if you want some spacing inside the form */
  }

  .input-container textarea {
    flex-grow: 1; /* Ensure it grows to fill the parent div */
    width: 100%; /* Make sure it takes the full width */
    height: 100%;
    border: 1px solid #ccc;
    padding: 10px;
    resize: none; /* Optional: Prevent manual resizing */
    overflow-y: auto; /* Enable vertical scroll when content exceeds */
  }

  .input-row {
    height: 10dvh;
    display: flex;
    align-items: center;
    padding: 10px;
  }

  .input-row input {
    flex-grow: 1;
    margin-right: 10px;
    padding: 10px;
  }

  .input-row button {
    padding: 10px;
  }
</style>
