key_check <- \(algo, len) {

  if (is.na(algo) || is.na(len)) return(NA_character_)

  if (algo == "dsa") {
    "❌ Key needs to be replaced; The DSA algorithm should not be used"
  } else if (algo == "rsa") {
    if (len >= 4096) {
      "✅ Key is safe"
    } else if (len >= 2048) {
      "✅ Key is safe; For the RSA algorithm at least 2048, recommended 4096"
    } else {
      "❌ Key needs to be replaced; For the RSA algorithm at least 2048, recommended 4096"
    }
  } else if (algo == "ecdsa") {
    if  (len == 521) {
      "✅ Key is safe"
    } else {
      "❌ For the ECDSA algorithm, it should be 521"
    }
  } else if (algo == "ed25519") {
    if  (len >= 256) {
      "✅ Key is safe"
    } else {
      "❌ For the ED25519, the key size should be 256 or larger"
    }
  }

}