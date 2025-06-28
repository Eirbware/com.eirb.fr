<script lang="ts">
  import { preview } from "../runes/preview.svelte";
  import { markdownContent } from "../runes/markdown-content.svelte";
  import Classic from "./Classic.svelte";
</script>

{#if preview.state}
  <!-- TODO: import Telegram -->
  <Classic markdownContent={markdownContent.content}></Classic>
{/if}
