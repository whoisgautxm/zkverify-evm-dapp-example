const fs = require("fs");
const { zkVerifySession } = require("zkverifyjs");
require("dotenv").config({ path: [".env", ".env.secrets"] });

async function run() {
  const proof = require("./proof.json");
  // Load verification key from file
  const vk = proof.image_id;

  // Establish a session with zkVerify
  const session = await zkVerifySession
    .start()
    .Custom("wss://testnet-rpc.zkverify.io")
    .withAccount("afford scale strong common joy concert hidden pudding screen cube pistol member");

  // Send verification key to zkVerify for registration
  const { transactionResult } = await session
    .registerVerificationKey()
    .risc0()
    .execute(vk);
    
  const { statementHash } = await transactionResult;
  console.log(`vk hash: ${statementHash}`);
}

run()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
