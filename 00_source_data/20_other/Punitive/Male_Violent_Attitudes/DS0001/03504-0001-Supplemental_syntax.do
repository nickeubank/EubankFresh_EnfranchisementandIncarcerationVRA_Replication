/*-------------------------------------------------------------------------*
 |                                                                         
 |              STATA COMPANION PROGRAM FILE FOR ICPSR 03504
 |          JUSTIFYING VIOLENCE: ATTITUDES OF AMERICAN MEN, 1969
 |
 |
 | This Stata missing value recode program is provided for optional use with
 | the Stata system version of this data file as distributed by ICPSR.
 | The program replaces user-defined numeric missing values (e.g., -9)
 | with generic system missing "."  Note that Stata allows you to specify
 | up to 27 unique missing value codes.  Only variables with user-defined
 | missing values are included in this program.
 |
 | To apply the missing value recodes, users need to first open the
 | Stata data file on their system, apply the missing value recodes if
 | desired, then save a new copy of the data file with the missing values
 | applied.  Users are strongly advised to use a different filename when
 | saving the new file.
 |
 *------------------------------------------------------------------------*/

replace V9 = . if (V9 >= 9 )
replace V10 = . if (V10 >= 9 )
replace V11 = . if (V11 >= 9 )
replace V12 = . if (V12 >= 11 )
replace V14 = . if (V14 >= 96 )
replace V15 = . if (V15 >= 98 )
replace V16 = . if (V16 >= 9 )
replace V17 = . if (V17 >= 98 )
replace V18 = . if (V18 == 0)
replace V18 = . if (V18 >= 96 )
replace V19 = . if (V19 == 0)
replace V19 = . if (V19 >= 98 )
replace V20 = . if (V20 == 0)
replace V20 = . if (V20 >= 96 )
replace V21 = . if (V21 == 0)
replace V21 = . if (V21 >= 98 )
replace V22 = . if (V22 == 0)
replace V22 = . if (V22 >= 96 )
replace V23 = . if (V23 == 0)
replace V23 = . if (V23 >= 98 )
replace V24 = . if (V24 == 0)
replace V24 = . if (V24 >= 96 )
replace V25 = . if (V25 == 0)
replace V25 = . if (V25 >= 98 )
replace V26 = . if (V26 == 0)
replace V26 = . if (V26 >= 96 )
replace V27 = . if (V27 == 0)
replace V27 = . if (V27 >= 98 )
replace V28 = . if (V28 == 0)
replace V28 = . if (V28 >= 96 )
replace V29 = . if (V29 == 0)
replace V29 = . if (V29 >= 98 )
replace V30 = . if (V30 == 0)
replace V30 = . if (V30 >= 96 )
replace V31 = . if (V31 == 0)
replace V31 = . if (V31 >= 98 )
replace V32 = . if (V32 == 0)
replace V32 = . if (V32 >= 96 )
replace V33 = . if (V33 == 0)
replace V33 = . if (V33 >= 98 )
replace V34 = . if (V34 == 0)
replace V34 = . if (V34 >= 96 )
replace V35 = . if (V35 == 0)
replace V35 = . if (V35 >= 98 )
replace V36 = . if (V36 >= 9 )
replace V37 = . if (V37 == 0)
replace V37 = . if (V37 >= 9 )
replace V38 = . if (V38 == 0)
replace V38 = . if (V38 >= 9 )
replace V39R1 = . if (V39R1 >= 95 )
replace V39R2 = . if (V39R2 >= 95 )
replace V39R3 = . if (V39R3 >= 95 )
replace V39R4 = . if (V39R4 >= 95 )
replace V40R1 = . if (V40R1 == 0)
replace V40R1 = . if (V40R1 >= 988 )
replace V40R2 = . if (V40R2 == 0)
replace V40R2 = . if (V40R2 >= 988 )
replace V40R3 = . if (V40R3 == 0)
replace V40R3 = . if (V40R3 >= 988 )
replace V40R4 = . if (V40R4 == 0)
replace V40R4 = . if (V40R4 >= 988 )
replace V41R1 = . if (V41R1 >= 95 )
replace V41R2 = . if (V41R2 >= 95 )
replace V41R3 = . if (V41R3 >= 95 )
replace V42R1 = . if (V42R1 == 0)
replace V42R1 = . if (V42R1 >= 988 )
replace V42R2 = . if (V42R2 == 0)
replace V42R2 = . if (V42R2 >= 988 )
replace V42R3 = . if (V42R3 == 0)
replace V42R3 = . if (V42R3 >= 988 )
replace V43R1 = . if (V43R1 >= 95 )
replace V43R2 = . if (V43R2 >= 95 )
replace V44R1 = . if (V44R1 == 0)
replace V44R1 = . if (V44R1 >= 988 )
replace V44R2 = . if (V44R2 == 0)
replace V44R2 = . if (V44R2 >= 988 )
replace V45 = . if (V45 >= 8 )
replace V46 = . if (V46 >= 8 )
replace V47 = . if (V47 >= 8 )
replace V48 = . if (V48 >= 8 )
replace V49 = . if (V49 >= 8 )
replace V50 = . if (V50 >= 8 )
replace V51 = . if (V51 >= 8 )
replace V52 = . if (V52 >= 8 )
replace V53 = . if (V53 >= 8 )
replace V54 = . if (V54 >= 8 )
replace V55 = . if (V55 >= 8 )
replace V56 = . if (V56 >= 8 )
replace V57 = . if (V57 >= 8 )
replace V58 = . if (V58 >= 8 )
replace V59 = . if (V59 >= 8 )
replace V60R1 = . if (V60R1 >= 95 )
replace V60R2 = . if (V60R2 >= 95 )
replace V61R1 = . if (V61R1 == 0)
replace V61R1 = . if (V61R1 >= 988 )
replace V61R2 = . if (V61R2 == 0)
replace V61R2 = . if (V61R2 >= 988 )
replace V62 = . if (V62 >= 8 )
replace V63 = . if (V63 >= 8 )
replace V64 = . if (V64 >= 8 )
replace V65 = . if (V65 >= 8 )
replace V66 = . if (V66 >= 8 )
replace V67 = . if (V67 >= 8 )
replace V68 = . if (V68 >= 6 )
replace V69 = . if (V69 >= 8 )
replace V70 = . if (V70 >= 8 )
replace V71 = . if (V71 >= 5 )
replace V72 = . if (V72 >= 8 )
replace V73 = . if (V73 >= 8 )
replace V74 = . if (V74 >= 8 )
replace V75 = . if (V75 >= 8 )
replace V76 = . if (V76 >= 8 )
replace V77 = . if (V77 >= 8 )
replace V78 = . if (V78 >= 8 )
replace V79 = . if (V79 == 0)
replace V79 = . if (V79 >= 98 )
replace V80 = . if (V80 >= 8 )
replace V81 = . if (V81 >= 8 )
replace V82 = . if (V82 >= 9 )
replace V83 = . if (V83 >= 8 )
replace V84 = . if (V84 == 0)
replace V84 = . if (V84 >= 8 )
replace V85 = . if (V85 == 0)
replace V85 = . if (V85 >= 8 )
replace V86 = . if (V86 == 0)
replace V86 = . if (V86 >= 8 )
replace V87 = . if (V87 == 0)
replace V87 = . if (V87 >= 8 )
replace V88 = . if (V88 == 0)
replace V88 = . if (V88 >= 8 )
replace V89 = . if (V89 == 0)
replace V89 = . if (V89 >= 8 )
replace V90 = . if (V90 >= 8 )
replace V91 = . if (V91 >= 8 )
replace V92 = . if (V92 >= 8 )
replace V93 = . if (V93 >= 8 )
replace V94 = . if (V94 >= 8 )
replace V95 = . if (V95 >= 8 )
replace V96 = . if (V96 >= 6 )
replace V97 = . if (V97 >= 8 )
replace V98 = . if (V98 >= 8 )
replace V99 = . if (V99 >= 8 )
replace V100 = . if (V100 >= 8 )
replace V101R1 = . if (V101R1 == 0)
replace V101R1 = . if (V101R1 >= 98 )
replace V101R2 = . if (V101R2 == 0)
replace V101R2 = . if (V101R2 >= 98 )
replace V102R1 = . if (V102R1 == 0)
replace V102R1 = . if (V102R1 >= 98 )
replace V102R2 = . if (V102R2 == 0)
replace V102R2 = . if (V102R2 >= 98 )
replace V103 = . if (V103 >= 8 )
replace V104 = . if (V104 >= 8 )
replace V105R1 = . if (V105R1 == 0)
replace V105R1 = . if (V105R1 >= 98 )
replace V105R2 = . if (V105R2 == 0)
replace V105R2 = . if (V105R2 >= 98 )
replace V106R1 = . if (V106R1 == 0)
replace V106R1 = . if (V106R1 >= 98 )
replace V106R2 = . if (V106R2 == 0)
replace V106R2 = . if (V106R2 >= 98 )
replace V107 = . if (V107 >= 8 )
replace V108 = . if (V108 >= 8 )
replace V109 = . if (V109 >= 8 )
replace V110 = . if (V110 == 0)
replace V110 = . if (V110 >= 98 )
replace V111 = . if (V111 >= 8 )
replace V112 = . if (V112 >= 8 )
replace V113 = . if (V113 >= 9 )
replace V114 = . if (V114 >= 8 )
replace V115 = . if (V115 == 0)
replace V115 = . if (V115 >= 8 )
replace V116 = . if (V116 == 0)
replace V116 = . if (V116 >= 8 )
replace V117 = . if (V117 == 0)
replace V117 = . if (V117 >= 8 )
replace V118 = . if (V118 == 0)
replace V118 = . if (V118 >= 8 )
replace V119 = . if (V119 == 0)
replace V119 = . if (V119 >= 8 )
replace V120 = . if (V120 == 0)
replace V120 = . if (V120 >= 8 )
replace V121 = . if (V121 >= 8 )
replace V122 = . if (V122 >= 8 )
replace V123 = . if (V123 >= 8 )
replace V124 = . if (V124 >= 8 )
replace V125 = . if (V125 >= 8 )
replace V126 = . if (V126 >= 8 )
replace V127 = . if (V127 >= 6 )
replace V128 = . if (V128 == 0)
replace V128 = . if (V128 >= 98 )
replace V129R1 = . if (V129R1 == 0)
replace V129R1 = . if (V129R1 >= 98 )
replace V129R2 = . if (V129R2 == 0)
replace V129R2 = . if (V129R2 >= 98 )
replace V130 = . if (V130 >= 8 )
replace V131 = . if (V131 >= 6 )
replace V132R1 = . if (V132R1 == 0)
replace V132R1 = . if (V132R1 >= 98 )
replace V132R2 = . if (V132R2 == 0)
replace V132R2 = . if (V132R2 >= 98 )
replace V133 = . if (V133 >= 6 )
replace V134 = . if (V134 == 0)
replace V134 = . if (V134 >= 98 )
replace V135 = . if (V135 >= 4 )
replace V136 = . if (V136 >= 8 )
replace V137 = . if (V137 >= 8 )
replace V138 = . if (V138 >= 8 )
replace V139 = . if (V139 >= 9 )
replace V140 = . if (V140 >= 6 )
replace V141 = . if (V141 >= 6 )
replace V142 = . if (V142 >= 8 )
replace V143 = . if (V143 >= 8 )
replace V144 = . if (V144 >= 8 )
replace V145 = . if (V145 >= 8 )
replace V146 = . if (V146 >= 8 )
replace V147 = . if (V147 >= 8 )
replace V148 = . if (V148 >= 8 )
replace V149 = . if (V149 >= 8 )
replace V150 = . if (V150 >= 8 )
replace V151 = . if (V151 >= 8 )
replace V152 = . if (V152 >= 8 )
replace V153 = . if (V153 >= 8 )
replace V154 = . if (V154 >= 8 )
replace V155 = . if (V155 >= 8 )
replace V156 = . if (V156 >= 8 )
replace V157 = . if (V157 >= 8 )
replace V158 = . if (V158 >= 8 )
replace V159 = . if (V159 >= 8 )
replace V160 = . if (V160 >= 8 )
replace V161 = . if (V161 >= 8 )
replace V162 = . if (V162 >= 8 )
replace V163 = . if (V163 >= 8 )
replace V164 = . if (V164 >= 8 )
replace V165 = . if (V165 >= 8 )
replace V166 = . if (V166 >= 8 )
replace V167 = . if (V167 >= 8 )
replace V168 = . if (V168 >= 8 )
replace V169 = . if (V169 >= 8 )
replace V170 = . if (V170 >= 8 )
replace V171 = . if (V171 >= 8 )
replace V172 = . if (V172 >= 8 )
replace V173 = . if (V173 >= 8 )
replace V174 = . if (V174 >= 8 )
replace V175 = . if (V175 >= 8 )
replace V176 = . if (V176 >= 8 )
replace V177 = . if (V177 >= 8 )
replace V178 = . if (V178 >= 9 )
replace V179 = . if (V179 >= 8 )
replace V180 = . if (V180 >= 9 )
replace V181R1 = . if (V181R1 == 0)
replace V181R1 = . if (V181R1 >= 98 )
replace V181R2 = . if (V181R2 == 0)
replace V181R2 = . if (V181R2 >= 98 )
replace V182R1 = . if (V182R1 == 0)
replace V182R1 = . if (V182R1 >= 98 )
replace V182R2 = . if (V182R2 == 0)
replace V182R2 = . if (V182R2 >= 98 )
replace V183 = . if (V183 >= 8 )
replace V184 = . if (V184 >= 8 )
replace V185R1 = . if (V185R1 == 0)
replace V185R1 = . if (V185R1 >= 98 )
replace V185R2 = . if (V185R2 == 0)
replace V185R2 = . if (V185R2 >= 98 )
replace V186R1 = . if (V186R1 == 0)
replace V186R1 = . if (V186R1 >= 98 )
replace V186R2 = . if (V186R2 == 0)
replace V186R2 = . if (V186R2 >= 98 )
replace V187 = . if (V187 >= 8 )
replace V188 = . if (V188 >= 8 )
replace V189 = . if (V189 >= 9 )
replace V190 = . if (V190 >= 9 )
replace V191 = . if (V191 >= 9 )
replace V192 = . if (V192 >= 9 )
replace V193 = . if (V193 >= 9 )
replace V194 = . if (V194 >= 9 )
replace V195 = . if (V195 >= 9 )
replace V196 = . if (V196 >= 9 )
replace V197 = . if (V197 >= 9 )
replace V198 = . if (V198 >= 9 )
replace V199 = . if (V199 >= 9 )
replace V200 = . if (V200 >= 9 )
replace V201 = . if (V201 >= 9 )
replace V202 = . if (V202 >= 9 )
replace V203 = . if (V203 >= 9 )
replace V204 = . if (V204 >= 9 )
replace V205 = . if (V205 >= 9 )
replace V206 = . if (V206 >= 9 )
replace V207 = . if (V207 == 0)
replace V207 = . if (V207 >= 9 )
replace V208 = . if (V208 >= 98 )
replace V209 = . if (V209 >= 98 )
replace V210 = . if (V210 >= 98 )
replace V211 = . if (V211 >= 91 )
replace V212 = . if (V212 >= 8 )
replace V213 = . if (V213 == 0)
replace V213 = . if (V213 >= 8 )
replace V214 = . if (V214 == 0)
replace V214 = . if (V214 >= 8 )
replace V215 = . if (V215 >= 8 )
replace V216 = . if (V216 == 0)
replace V216 = . if (V216 >= 98 )
replace V217 = . if (V217 >= 8 )
replace V218 = . if (V218 == 0)
replace V218 = . if (V218 >= 98 )
replace V219 = . if (V219 >= 9 )
replace V220 = . if (V220 == 0)
replace V220 = . if (V220 >= 8 )
replace V221 = . if (V221 == 0)
replace V221 = . if (V221 >= 900 )
replace V222 = . if (V222 == 0)
replace V222 = . if (V222 >= 9 )
replace V223 = . if (V223 == 0)
replace V223 = . if (V223 >= 9 )
replace V224 = . if (V224 == 0)
replace V224 = . if (V224 >= 900 )
replace V225 = . if (V225 == 0)
replace V225 = . if (V225 >= 9 )
replace V226 = . if (V226 == 0)
replace V226 = . if (V226 >= 9 )
replace V227 = . if (V227 >= 98 )
replace V228 = . if (V228 == 0)
replace V228 = . if (V228 >= 8 )
replace V229 = . if (V229 == 0)
replace V229 = . if (V229 >= 9 )
replace V230 = . if (V230 == 0)
replace V230 = . if (V230 >= 8 )
replace V231 = . if (V231 == 0)
replace V231 = . if (V231 >= 98 )
replace V232 = . if (V232 >= 8 )
replace V233 = . if (V233 == 0)
replace V233 = . if (V233 >= 9 )
replace V234 = . if (V234 == 0)
replace V234 = . if (V234 >= 8 )
replace V235 = . if (V235 >= 98 )
replace V236 = . if (V236 == 0)
replace V236 = . if (V236 >= 8 )
replace V237 = . if (V237 >= 98 )
replace V238 = . if (V238 == 0)
replace V238 = . if (V238 >= 8 )
replace V239 = . if (V239 >= 8 )
replace V240 = . if (V240 >= 99 )
replace V241 = . if (V241 >= 8 )
replace V242 = . if (V242 >= 8 )
replace V243 = . if (V243 >= 8 )
replace V244 = . if (V244 == 0)
replace V244 = . if (V244 >= 9 )
replace V245 = . if (V245 == 0)
replace V245 = . if (V245 >= 9 )
replace V246 = . if (V246 >= 8 )
replace V247 = . if (V247 >= 18 )
replace V248 = . if (V248 >= 8 )
replace V249 = . if (V249 == 0)
replace V249 = . if (V249 >= 8 )
replace V250 = . if (V250 >= 8 )
replace V251 = . if (V251 >= 8 )
replace V252 = . if (V252 >= 8 )
replace V256 = . if (V256 >= 9 )
replace V257 = . if (V257 >= 9 )
replace V259 = . if (V259 >= 9 )
replace V261 = . if (V261 >= 9 )
replace V262 = . if (V262 >= 9 )
replace V263 = . if (V263 >= 9 )
replace V264 = . if (V264 >= 9 )
replace V265 = . if (V265 >= 9 )
replace V266 = . if (V266 >= 9 )
replace V267 = . if (V267 >= 11 )
replace V268 = . if (V268 >= 11 )
replace V269 = . if (V269 >= 9 )
replace V270 = . if (V270 >= 9 )
replace V271 = . if (V271 >= 9 )
replace V272 = . if (V272 >= 9 )
replace V273 = . if (V273 >= 9 )
replace V274 = . if (V274 >= 9 )
replace V275 = . if (V275 >= 9 )
replace V276 = . if (V276 >= 9 )
replace V277 = . if (V277 >= 9 )
replace V278 = . if (V278 >= 9 )
replace V279 = . if (V279 >= 9 )
replace V280 = . if (V280 >= 9 )
replace V281 = . if (V281 >= 9 )
replace V282 = . if (V282 >= 9 )
replace V283 = . if (V283 >= 9 )
replace V284 = . if (V284 >= 9 )
replace V285 = . if (V285 >= 99 )
replace V286 = . if (V286 >= 4 )
replace V287 = . if (V287 >= 99 )
replace V288 = . if (V288 >= 4 )
replace V289 = . if (V289 >= 99 )
replace V290 = . if (V290 >= 4 )
replace V291 = . if (V291 >= 99 )
replace V295 = . if (V295 >= 9 )
replace V297 = . if (V297 >= 9 )
replace V299 = . if (V299 >= 9 )
replace V301 = . if (V301 >= 9 )
replace V303 = . if (V303 >= 9 )
replace V305 = . if (V305 >= 9 )
replace V307 = . if (V307 >= 9 )
replace V309 = . if (V309 >= 9 )
replace V311 = . if (V311 >= 9 )
replace V313 = . if (V313 >= 9 )
replace V315 = . if (V315 >= 9 )
replace V317 = . if (V317 >= 9 )


