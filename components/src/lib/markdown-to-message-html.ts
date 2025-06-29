import markdownit from "markdown-it";
import taskLists from "markdown-it-task-lists";
import highlightjs from "markdown-it-highlightjs";
import { spoiler } from "@mdit/plugin-spoiler";

const md = markdownit({
  html: true, // for the <u> tag; TODO: sanitize with allowing <u> only
  breaks: true,
  linkify: true,
})
  .use(taskLists)
  .use(highlightjs)
  .disable(["table"])
  .use(spoiler);

interface MarkdownRenderingCustomProcess {
  pre: (mdContent: string) => string;
  post: (htmlContent: string) => string;
}

// --- disable <p> and replace <p/> by <br/> ---

md.renderer.rules.paragraph_open = () => {
  return "";
};
md.renderer.rules.paragraph_close = (tokens, idx) => {
  if (tokens[idx + 1] && tokens[idx + 1].tag === "p") return "<br/>";
  return "";
};

// --- disable <p> and replace <p/> by <br/> ---

const allowAdditionalLinebreaks: MarkdownRenderingCustomProcess = {
  pre: (mdContent: string) => {
    // Transform 2+n linebreaks into 2 linebreaks and n+1 placeholders
    // paragraphs, so they will be transformed into consecutive paragraph
    // tags that will be transformed into <br/>
    // enable this to lengthen the height space between two paragraphs
    // as in message editors
    const lineBreakPairToLineBreakTag = (s: string) =>
      s.replace(
        /\n{2,}/g,
        (match) => "\n\n" + "\n\n%%%deadbeef%%%\n\n".repeat(match.length - 1),
      );
    return mdContent
      .split("```")
      .map((part, i) => (i % 2 ? part : lineBreakPairToLineBreakTag(part)))
      .join("```");
  },

  post: (htmlContent: string) => htmlContent.replace(/%%%deadbeef%%%/g, ""),
};

const spoilerProcessing: MarkdownRenderingCustomProcess = {
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

const processes: MarkdownRenderingCustomProcess[] = [
  spoilerProcessing,
  allowAdditionalLinebreaks,
];
const pipe = (ps: ((s: string) => string)[]) => (s: string) =>
  ps.reduce((acc, fn) => fn(acc), s);

const preprocesses = pipe(processes.map((p) => p.pre));
const postprocesses = pipe(processes.map((p) => p.post));

export const renderMarkdown = pipe([
  preprocesses,
  (s) => md.render(s),
  postprocesses,
]);
