import { use, run } from "./src/run.ts"

use("romanize.pl")

await Array.fromAsync(run
    (await Deno.readTextFile("sketch/main.pl"))
    (`
        romanize(Res, "imelda"),
        romanize("바람", Res2).
        
    `)
).then(x => {
    console.log(
        JSON.stringify(x, void 0, 2)
        // x.map(answer =>
        //     answer.status == "success"
        //         ? answer.answer.Res
        //         : "<failure>"
        // )
    )
})
