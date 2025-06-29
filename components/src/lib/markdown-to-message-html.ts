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

const allowAdditionalLinebreaks: MarkdownRenderingCustomProcess = {
  pre: (mdContent: string) =>
    mdContent.replace(/\n{3,}/g, (match) => {
      const extraBreaks = match.length - 2;
      return "\n\n" + "<br/>".repeat(extraBreaks) + "\n\n";
    }),
  post: (htmlContent: string) => htmlContent,
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
