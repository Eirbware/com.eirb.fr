<script lang="ts">
  import markdownit from "markdown-it";
  import taskLists from "markdown-it-task-lists";
  import highlightjs from "markdown-it-highlightjs";
  import { spoiler } from "@mdit/plugin-spoiler";

  import "./css/classic-renderer.css";

  const md = markdownit({
    html: true, // for the <u> tag; TODO: sanitize with allowing <u> only
    breaks: true,
    linkify: true,
  })
    .use(taskLists)
    .use(highlightjs)
    .disable(["table"])
    .use(spoiler);

  const spoilerProcessing = {
    pre: (mdContent: string) =>
      mdContent
        // ensure we do not have problem with existing %e% (not very probable)
        .replace(/%/g, "+-%-+")
        // we keep the original '!'s out of the analysis
        .replace(/!/g, "%e%")
        // we replace the '|'s by '!'s before the processing by the mdit
        // spoiler plugin
        .replace(/\|/g, "!"),
    post: (htmlContent: string) =>
      htmlContent
        // The remaining '!'s are originally non-delimiter '|'s
        .replace(/!/g, "|")
        // Restore the original '!'s
        .replace(/%e%/g, "!")
        // Restore the original '%'s
        .replace(/\+-%-\+/g, "%"),
  };

  function renderMarkdown(mdContent: string) {
    return spoilerProcessing.post(md.render(spoilerProcessing.pre(mdContent)));
  }

  export let markdownContent: string = "";
</script>

<div class="rendered-html">
  {@html renderMarkdown(markdownContent)}
</div>
