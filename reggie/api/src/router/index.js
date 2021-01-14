//
// Reggie
//
// Copyright © 2018 Province of British Columbia
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Created by Jason Leach on 2018-01-10.
//

'use strict';

import cors from 'cors';
import config from '../config';
import ehlo from './routes/ehlo';
import sso from './routes/ssoUsers';

let allowlist = [];
if (config.get('environment') === 'development') {
  allowlist.push('*');
} else {
  allowlist.push(config.get('appUrl'));
}

console.log(`Allowed CORS: ${JSON.stringify(allowlist)}`);

const options = {
  origin: (origin, callback) => {
    if (allowlist.indexOf('*') !== -1 || allowlist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error(`Origin ${origin} not allowed by CORS`));
    }
  },
  allowedHeaders: ['Accept', 'Content-Type', 'Authorization'],
  credentials: true,
};

// eslint-disable-next-line import/prefer-default-export
export const router = app => {
  app.use(cors(options));
  app.use('/api/v1/ehlo', ehlo); // probes
  app.use('/api/v1/sso', sso); // SSO requests
};
