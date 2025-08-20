# 📡 `com.eirb.fr` 📨

This project includes a web server offering an interface to write Markdown
messages which is then sent to the user within a telegram bot with the right
formatting.

The main aim is to enable people writing cross-platform messages from a single
Markdown source text, meaning that, with one source content, we can easily send
a message on Discord, Telegram, a webmail, etc.

## 📦 Deploy and run in production

1. The two entrypoints files are the `docker-compose.yml` and the `Dockerfile`,
   at the root of the repository.

2. In their directory on the remote machine, be sure that the sources files and
   the built assets of the frontend are available, like in the file tree below:

    ```sh
    # All the files below are required
    .
    ├── Dockerfile
    ├── docker-compose.yml  # set the correct external port before
    ├── .env.production
    ├── README.md
    ├── frontend
    │   └── build # directory with the built frontend assets
    ├── poetry.lock
    ├── pyproject.toml
    ├── src
    └── templates
    ```

    If you have missing files (such as the frontend assets that are not built
    or the `.env.production` which is not written), see
    [this section](#🏗️-building-for-deployment)

3. Run the docker-compose file. The Flask server will be reachable on port
   `8000` and the Telegram bot will listen all `/start` commands.

   ```sh
   docker compose up # -d if you want to detach the run
   ```

## Development and building dependencies

We assume you carry out the application building on your machine.

### Requirements

- `python` (>=3.13)
- `poetry` (>=2.1)
- `bunjs` (>=1.2.19) on the PATH with `bun`
  If you want to install it from npm, it is strongly advised to use npm with a
version of Node.js greater or equal to `24.1.1` (for the support of the last
version of sveltekit and vitejs to be suitable at runtime)
- `just` if you are lazy to run the commands

You can set a local, rootless and isolated environment with all these tools
thanks to `conda` with running this command. The `justfile` fully supports an
installation with this environment manager:

```sh
# this installs the requirements above (excepted just)
# and it also installs all the Python/BunJS libraries of the project
just conda-full-install
```

Then, be sure to always source the environment of `./.com-env` when you work on
the project. To do so, you can either:

- Always use the mirror rules of the `justfile` starting with the `conda-`
prefix. For instance,

  ```sh
  # equivalent of $ just build
  # but with automatically using the ./.com-env environment
  just conda-build
  ```

- Or run this command in your shell before using the CLIs and the basic rules
of the `justfile`:

  ```sh
  conda activate ./.com-env
  # then run just, bun, python, poetry, etc...
  # e.g, $ just build
  ```

To purely clear the isolated environment

```sh
# also remove all the libraries required by the project
# and the built files
just conda-full-clean
```

### Install

If you use conda, the previous installation rule is sufficient.

Else, you can use the justfile:

```sh
just install # install both the deps for the frontend and the backend
```

## 🔑 Application credentials

### Setup the `.env` (or `.env.production`)

Use the file `/.env.example` to get started, and follow the next instruction to
set up the bot.

Add the token and the username of the sender bot in the `/.env` (or
`/.env.production`) file. The username is for displaying purpose.

```env
BOT_TOKEN="your_telegram_bot_token"
PUBLIC_BOT_USERNAME="@YourBotUsername"
```

### How to get these credentials on Telegram

The bot token and username will be got if you create the bot by talking with
@FatherBot.

## 🏗️ Building for deployment

1. You must have installed the [development/building
dependencies](#development-and-building-dependencies) on your local machine.

2. Build the frontend assets with this command

   ```sh
   just vite-build
   ```

3. Fill the `.env.production` file, as described in [the section about
credentials](#🔑-application-credentials).

Your directory is ready to be run in production mode 🥳! If you want to package
all the required files for a **deployment with docker** (as in [this
section](#📦-deploy-and-run-in-production)), run this rule

```sh
just build
```

A `ready_to_deploy.tar.gz` archive will be produced. Just unpack it on your
server (be sure the output port is correctly set in the `docker-compose.yml`)
and run `docker compose up`.

## 💻 Run in development

Be sure all the [development/building
dependencies](#development-and-building-dependencies) are installed on your
local machine

The application is divided into three sub-applications :

- the flask server
- the bot dispatcher to give to the user its chat identifier
- the vite-svelte frontend application with the user interface that flask will
serve

For a convenient development experience, run the three sub-applications
separately with those three rules

```sh
# for developing on the frontend
just vite-dev

# for developing on the backend (the frontend must have been built before)
just flask-dev # before, run $ just vite-build

# in production, the dispatcher run in asynchronous concurrency with the
# flask server
just dispatcher-dev 
```

## 📝 API documentation

### `POST` `/send`

Requires the `"Content-Type": "application/json"` header with a json body with
the following structure

```json
{
    "chat_id": "the id of your chat with the bot",
    "content_type": "html", # this single option will be removed in the future
    "content": "Your <em>beautiful</em> message with the <code>HTML</code> <strong>format</strong>."
}
```

Send the given message in the channel with the set-up chat id.

### `GET` `/`

Render the frontend interface to input the markdown, render it in HTML and then
send the message as in the previewed html.

### About the format

### Markdown

The writable Markdown follow the [CommonMark](https://spec.commonmark.org/) specification, with those additional specificities:

- all linebreaks in addition with those allowed by the specification are kept,
  as we are writing a message instead of a README or a webpage content.
  *Current caveat: the code blocks are circled by a not removable linebreak for
  now*

- The only supported HTML tag is the `<u>`. The others are automatically
broken.
- Use `||` for spoilers.

### Rendered HTML

Use `<span class="spoiler"/></span>` for the spoiler.

The `<p>` tags are removed from the rendered markdown, though they are
processable by the Flask server (but then the Telegram writer adds weird
newlines).

The frontend interface use the rendered HTML to request from the flask server a
message sending. It is more tolerant with the markdown syntax and tries to be
as transparent as possible with the final got message in telegram.

## 🧪 Test the server

TODO
