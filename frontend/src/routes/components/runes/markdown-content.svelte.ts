import { getDraft } from "../store-inputs";

export const markdownContent = $state({ content: getDraft() });
