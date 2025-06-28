<script lang="ts">
  import markdownit from "markdown-it";
  import "./css/classic-renderer.css";
  // TODO: add options
  const md = markdownit();
  export let markdownContent: string = "";
</script>

<div class="rendered-html">
  {@html md.render(markdownContent)}
</div>
