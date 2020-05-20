import json
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.bditroop import BDITroop
from pygomas.bdisoldier import BDISoldier
from pygomas.ontology import HEALTH
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
        
        @actions.add(".AFormar", 2)      
        def _AFormar(agent, term, intention):
            """
            Gives the position where agents should be placed
            :param number: number of agents
            :param type: type of the agents
            :rtype list
            """
            args = asp.grounded(term.args, intention.scope)
            
            
            yield

      
#        super().__init__(actions=example_agent_actions, *args, **kwargs)
