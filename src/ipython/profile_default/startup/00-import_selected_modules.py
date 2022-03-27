import pandas as pd
import numpy as np

from dataclasses import dataclass, InitVar, field
from enum import Enum, Flag, auto, unique
from functools import reduce

print("\nWarning: pre-loading selected modules, see your config", end='')
