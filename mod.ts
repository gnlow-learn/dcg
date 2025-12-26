import { load, Prolog } from "./deps.ts"

await load()

const pl = new Prolog()

await pl.consultText("person(socrates).")

const query = pl.query("person(Who).")
for await (const answer of query) {
    console.log(answer)
}
