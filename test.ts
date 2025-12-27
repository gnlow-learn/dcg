import { use, query } from "./src/run.ts"

use("romanize.pl")

await query(`
    phrase(sentence(_, IR), "A butterfly saw a flower"),
    phrase(sentence(_, IR), Res).
`, `
    IR = s(decl,active,past,pred(see,agent(butterfly,a),obj(flower,a))), Res = "나비가 꽃을 보았다".
    IR = s(decl,active,past,pred(see,agent(butterfly,a),obj(flower,a))), Res = "꽃을 나비가 보았다".
    IR = s(decl,active,past,pred(see,agent(butterfly,a),obj(flower,a))), Res = "A butterfly saw a flower".
`)
