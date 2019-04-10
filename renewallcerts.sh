#!/bin/bash

salt '*' cmd.run 'certbot -n renew'

