import re
import pickle

class Rule:
    prop = ''
    expression = ''

    def __init__(self, prop: str, expression: str):
        self.prop = prop
        self.expression = expression


    def match(self, data: dict) -> bool:
        result = re.match(self.expression, data[self.prop]) != None
        return result

class RuleSet:
    value = ''
    rules = []

    def __init__(self, value: str, rules):
        self.value = value
        self.rules = rules

class IconResolver:
    _rules = []
    _cache = {}


    def __init__(self, rules):
        self._rules = [self._parse_rule(rule) for rule in rules]


    def resolve(self, app):
        id = pickle.dumps(app)

        if id in self._cache:
            return self._cache[id]

        out = ''
        for ruleSet in self._rules:
            matches = True
            for rule in ruleSet.rules:
                matches = matches and rule.match(app)
            if matches:
                out = ruleSet.value
                break

        self._cache[id] = out

        return out


    def _parse_rule(self, rule) -> RuleSet:
        parts = rule[0].split(';', 1)
        rules: list[Rule] = []

        if len(parts) > 1:
            for part in parts:
                rules.append(self._split_property_matcher(part))
        else:
            rules.append(self._split_property_matcher(rule[0]))

        return RuleSet(rule[1], rules)

    def _split_property_matcher(self, propMatcher: str) -> Rule:
        prop = 'class'
        exp = ''

        parts = propMatcher.split('=', 1)
        if len(parts) > 1:
            prop = parts[0]
            match = parts[1]
            exp = re.escape(match).replace('\\*', '.+')
        else:
            match = parts[0]
            exp = re.escape(match).replace('\\*', '.+')

        return Rule(prop, exp)
