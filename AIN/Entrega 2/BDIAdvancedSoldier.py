import json
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.bditroop import BDITroop
from pygomas.bdisoldier import BDISoldier
from pygomas.ontology import HEALTH
from pygomas.ontology import AMMO
from agentspeak import Actions
from agentspeak import grounded
from agentspeak.stdlib import actions as asp_action

#ddudas
import agentspeak as asp
#fin


from pygomas.agent import LONG_RECEIVE_WAIT

class BDIMAdvancedSoldier(BDISoldier):

     def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.addfunction(".elegirAscender", list)      
        def _Ascender(listaSoldados):
            """
            Gives de soldier nearest the flag
            :param number: list of soldiers
            :param type: type of the agents
            :rtype soldier
            """
            if len(listaSoldados) < 1:
                return []
            capi = listaSoldados[0]
            for sol in listaSoldados:
                if sol.health > capi.health:
                    capi = sol
                elif sol.health = salud:
                    if sol.ammo < capi.ammo:
                        capi = sol
            return capi

