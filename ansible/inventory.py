import os
import enum
import json
import subprocess

class Struct:
    def __init__(self, **entries):
        self.__dict__.update(entries)

class Environments (enum.Enum):
    PROD = "prod"
    STAGE = "stage"

class Modules (enum.Enum):
    APP = "app"
    DB = "db"

class Outputs (enum.Enum):
    EXT_IP_ADDRESS = "external_ip_address"

outputParams = {Outputs.EXT_IP_ADDRESS: "hosts"}

class TerraformUtils ():
    def __init__(self, environment):
        self.cwd = os.getcwd()
        self.env = environment
    def cdCurrent(self):
        os.chdir(self.cwd)
    def cdEnv(self):
        os.chdir(getStatePath (self.env))
    def captureOutputs(self):
        outputs = subprocess.run(["terraform","output","-json"], capture_output=True)
        return outputs.stdout
    def extractOutputs(self):
        self.cdEnv()
        outputsJson = self.captureOutputs()
        self.cdCurrent()
        return json.loads(outputsJson)

def validateParam (value, enumClass):
    if not isinstance(value, enumClass):
        raise TypeError("value \"" + value + "\" must be an instance of " + enumClass.__name__ + " Enum")

def getPythonInterpreter():
    return "/usr/local/bin/python3.8"

def getTerraformPath():
    return "../terraform"

def getStatePath (environment):
    validateParam (environment, Environments)
    return os.path.join (getTerraformPath(), environment.value)

def getInventoryFile():
    return "inventory.json"


def createOutputKey (output, module):
    validateParam (output, Outputs)
    validateParam (module, Modules)
    return output.value + "_" + module.value

def extractTerraformOutputs(environment, outputType, *modules):
    outputs = []
    rawOutputs = TerraformUtils(environment).extractOutputs()
    for module in modules:
        key = createOutputKey (outputType, module)
        extractedValue = rawOutputs[key]["value"]
        extracted = {
            "module": module.value,
            "param": outputParams[outputType],
            "value": extractedValue
        }
        outputs.append(Struct(**extracted))
    return outputs

def genDefaultHostVar():
    return {"ansible_host": "", "ansible_python_interpreter": getPythonInterpreter()}

def genModuleLabel(module):
    return module + "server"

def buildInventoryMetaSection(outputs):
    hostvars = {}
    for output in outputs:
        hostvar = genDefaultHostVar()
        hostvar["ansible_host"] = output.value
        hostvars[genModuleLabel(output.module)] = hostvar
    return {"hostvars":hostvars}

def bulidInventoryAllSection(outputs):
    children = ["ungrouped"]
    for output in outputs:
        children.append(output.module)
    return {"children": children}

def buildInventoryModuleSections(outputs):
    moduleSection = {}
    for output in outputs:
        moduleSection[output.module] = {output.param: [genModuleLabel(output.module)]}
    return moduleSection

def buildInventory(outputs):
    inventory = {}
    inventory["_meta"] = buildInventoryMetaSection(outputs)
    inventory["all"] = bulidInventoryAllSection(outputs)
    moduleSections = buildInventoryModuleSections(outputs)
    for module, sectionContent in moduleSections.items():
        inventory[module] = sectionContent
    return inventory

def saveInventory (inventory):
    with open (getInventoryFile(), "w") as inventiryFile:
        json.dump(inventory, inventiryFile, indent=4)

def run():
    outputs = extractTerraformOutputs(Environments.STAGE, Outputs.EXT_IP_ADDRESS, Modules.APP, Modules.DB)
    inventory = buildInventory(outputs)
    saveInventory (inventory)

run()
