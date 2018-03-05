/** 
 * Copyright 2018 Scott Wales
 *
 * \author  Scott Wales <scottwales@outlook.com.au>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "sqlite3.h"
#include <string.h>

// Return the string length as well
const char * sqlite_helper_column_text(sqlite3_stmt* stmt, int col, int* len) {
    const char * txt = sqlite3_column_text(stmt, col);
    *len = strlen(txt);
    return txt;
}

// Always copy memory
int sqlite_helper_bind_text(sqlite3_stmt* stmt, int col, const char * val, int len) {
    return sqlite3_bind_text(stmt, col, val, len, SQLITE_TRANSIENT);
}
