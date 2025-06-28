<script lang="ts">
  import "./css/classic-renderer.css";

  import { renderMarkdown } from "./markdown-to-message-html";

  export let markdownContent: string = "";
</script>

<div class="rendered-html">
  {@html renderMarkdown(markdownContent)}
</div>
