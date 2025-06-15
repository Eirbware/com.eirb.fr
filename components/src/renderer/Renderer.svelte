<script lang="ts">
import { preview } from "../runes/preview.svelte";
    import Classic from "./Classic.svelte";
</script>

{#if preview.state}
  <!-- TODO: import Telegram -->
  <Classic></Classic>
{/if}
