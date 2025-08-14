<script lang="ts">
  import { preview } from "../runes/preview.svelte";
  import { htmlRenderedContent } from "../runes/html-rendered-content.svelte";
	import Telegram from "./Telegram.svelte";
</script>

{#if preview.state}
  <Telegram htmlContent={htmlRenderedContent()}></Telegram>
{/if}
