<script lang="ts">
  import "./css/classic-renderer.css";

  let { htmlContent }: { htmlContent: string } = $props();
</script>

<div class="rendered-html">
  {@html htmlContent}
</div>
