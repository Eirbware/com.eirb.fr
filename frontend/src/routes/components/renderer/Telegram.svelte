<script lang="ts">
	import 'highlight.js/styles/default.css';
	import './css/telegram-new-renderer.css';
	import backgroundImage from './assets/telegram-chat-background.png?enhanced';

	import { browser } from '$app/environment';

	let { htmlContent }: { htmlContent: string } = $props();

	const TELEGRAM_CHAR_LIMIT_PER_MESSAGE = 4096;
  function distance_to_color(val: number, ref_treshold: number) {
    const distance = ref_treshold - val;
    if (distance > 0.1*ref_treshold) 
      return "13, 148, 136";
    if (distance > 0.05*ref_treshold)
      return "255, 179, 0";
    return "255, 0, 0";
  }
  const count_color_indicator = $derived(`--indic-color: ${distance_to_color(htmlContent.length, TELEGRAM_CHAR_LIMIT_PER_MESSAGE)}`);

	function renderSulgukCaveats(content: string) {
		/* Edit the HTML to add newlines around the code blocks, which is forced by
		 * the sulguk intergration in the backend.
		 */
		// TODO: for now, this preview is done only visually within the css
		return content;
	}

	function renderCodeHeader(content: string) {
		// TODO: use cheerio instead of the browser's dom
		const parser = new DOMParser();
		const rendered = parser.parseFromString(content, 'text/html');
		const codeHeader = (language: string | undefined) => {
			const newElt = rendered.createElement('div');
			newElt.classList.add('code-header');
			newElt.innerHTML = `<span class="code-header-name">${language ? language.charAt(0).toUpperCase() + language.slice(1) : 'copy'}</span>
<span class="code-header-button"></span>
<span class="code-header-button"></span>`;
			return newElt;
		};
		rendered.querySelectorAll('pre').forEach((preElt) => {
			const codeBlock = preElt.querySelector('code');
			if (codeBlock === null) return;
			const codeBlockLanguage: string | undefined = codeBlock.classList[1]?.split('language-')[1];
			preElt.insertBefore(codeHeader(codeBlockLanguage), codeBlock);
		});
		return rendered.documentElement.outerHTML;
	}

	function htmlToDisplayedHTML(content: string) {
		return renderSulgukCaveats(renderCodeHeader(content));
	}
</script>

<div class="telegram-renderer">
	<div class="chat-background">
		<enhanced:img src={backgroundImage} alt="telegram-background" />
	</div>
	<div class="char-count" style={count_color_indicator}>
		Character number: <code>{htmlContent.length}/{TELEGRAM_CHAR_LIMIT_PER_MESSAGE}</code>
	</div>
	<div class="telegram-bubble-content-wrapper">
		<div class="telegram-bubble-content">
			<div class="telegram-message-wrapper">
				<div class="telegram-message">
					{#if browser}
						{@html htmlToDisplayedHTML(htmlContent)}
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<style>
	.telegram-renderer {
		position: relative;
		height: 100vh;
	}

	.char-count {
		position: absolute;
		margin: 5px;
		z-index: 4;
		top: 0.5rem;
		right: 0.5rem;
		background-color: rgba(var(--indic-color), 0.5); /* teal-600 */
		color: white;
		padding: 0.5rem 1rem;
		border-radius: 0.5rem;
		font-size: 0.875rem; /* text-sm */
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}

	.char-count:hover {
		background-color: rgb(var(--indic-color)); /* teal-600 */
	}

	.chat-background enhanced\:img {
		position: absolute;
		top: 0;
		left: 0;
		height: 100vh;
		width: 100%;
		object-fit: cover;
		pointer-events: none; /* ensures it doesn't block content */
		z-index: 0;
	}

	.telegram-bubble-content-wrapper {
		padding: 30px;
		z-index: 1;
		height: 100%;
		overflow-y: auto;
	}
</style>
