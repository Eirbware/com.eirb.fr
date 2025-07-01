import { getDraft } from "../lib/store-inputs";

export const markdownContent = $state({ content: getDraft() });
