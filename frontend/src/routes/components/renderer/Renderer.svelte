<script lang="ts">
  import { preview } from "../runes/preview.svelte";
  import { htmlRenderedContent } from "../runes/html-rendered-content.svelte";
  import Classic from "./Classic.svelte";
</script>

{#if preview.state}
  <!-- TODO: import Telegram -->
  <Classic htmlContent={htmlRenderedContent()}></Classic>
{/if}
