import { run } from "./src/run.ts"

await Array.fromAsync(run
    (await Deno.readTextFile("sketch/a.pl"))
    (`
        IR = s(decl, active, past, pred(see, agent(butterfly, det(the)), obj(flower, det(a)))),
        phrase(ko_sentence(IR), Ko),
        phrase(en_sentence(IR), En).
    `)
).then(x => console.log(x))
