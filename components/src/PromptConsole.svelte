<script lang="ts">
  import { onMount } from "svelte";

  import { displayHelpModal } from "./runes/display-help-modal.svelte";
  import { markdownContent } from "./runes/markdown-content.svelte";
  import { htmlRenderedContent } from "./runes/html-rendered-content.svelte";

  import { postMessage } from "./lib/send-message";
  import { getChatId, setChatId, setDraft } from "./lib/store-inputs";

  let chatId: string = $state(getChatId());

  // When the runes will be update, the setChatId and setDraft will also be
  $effect(() => {
    setChatId(chatId);
  });
  $effect(() => {
    setDraft(markdownContent.content);
  });

  function messageSubmit(event: SubmitEvent) {
    event.preventDefault();
    postMessage(
      $state.snapshot(htmlRenderedContent()),
      $state.snapshot(chatId),
    );
  }

  function openHelp() {
    displayHelpModal.state = true;
  }

  let { botUsername, botLink }: { botUsername: string; botLink: string } =
    $props();

  const defaultText = `Enter your message here

> The previewed message will be sent to you by [\`${botUsername}\`](${botLink}). Contact him in private on Telegram, next run the \`/start\` command to get your chat id. Then, fill the field below with this chat id and click on *Submit* to get the message in your private Telegram chat.

Below you can get some samples of markdown syntax :

**bold \\*\\*text**
__bold \\_\\_text__

*italic \\*text*
_italic \\_text_
<u>\\<u\\>underline</u>
~~\\~\\~strikethrough~~
||\\|\\|spoiler||
**bold _italic bold ~~italic bold strikethrough ||italic bold strikethrough spoiler||~~ <u>underline italic bold_</u> bold**
[inline URL](http://www.example.com/)
👍
\`inline fixed-width code\`
\`\`\`
pre-formatted fixed-width code block
\`\`\`
\`\`\`python
# here is a pre-formatted fixed-width code block
# with Python code
for _ in range(2):
  print("ENSEIRB, ", end="")
print("On s'en...")
\`\`\`
>Block quotation started
>Block quotation continued
>Block quotation continued
>Block quotation continued
>The last line of the block quotation

For separating your parapraphs in your messages


The linebreaks are automatically kept ||though this does not respect the
CommonMark convention||

- [x] export to discord *(just copy your markdown)*
- [ ] export for webmail
- [x] export for telegram
`;
  onMount(() => {
    if ($state.snapshot(markdownContent.content) === "")
      markdownContent.content = defaultText;
  });
</script>

<form id="dataForm" onsubmit={messageSubmit} class="editor">
  <!-- Main markdown input div taking 90% of the height -->
  <div class="input-container">
    <!-- TODO: add the placeholders as slugs -->
    <textarea
      id="message"
      bind:value={markdownContent.content}
      name="message"
      placeholder="Enter your message here

The previewed message will be sent to you by {botUsername}. Contact him in private on Telegram, next run the '/start' command to get your chat id. Then, fill the field below with this chat id and click on Submit to get the message in your private Telegram chat.

"
    ></textarea>
  </div>

  <!-- Chat id input and submit button occupying the remaining 10% of
          the height -->
  <div class="input-row">
    <input
      id="chat-id"
      bind:value={chatId}
      type="text"
      placeholder="Enter your chat id"
      name="chat_id"
    />

    <!-- noform to prevent the button from triggering the form submit event -->
    <button
      form="noform"
      onclick={openHelp}
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
