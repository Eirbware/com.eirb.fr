<script lang="ts">
  import { preview } from "../runes/preview.svelte";
  import Classic from "./Classic.svelte";

  // TODO: replace with the rendered markdown
  const markdownContent = `The General Kenobi has said

> *Hello **there**!*

And I approve it`;
</script>

{#if preview.state}
  <!-- TODO: import Telegram -->
  <Classic markdownContent="{markdownContent}"></Classic>
{/if}
