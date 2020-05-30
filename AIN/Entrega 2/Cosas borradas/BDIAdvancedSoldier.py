import math
import json
import agentspeak
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.bditroop import BDITroop
from pygomas.bdisoldier import BDISoldier
from pygomas.ontology import HEALTH
from agentspeak import Actions
from agentspeak import grounded
import agentspeak as asp
from agentspeak.stdlib import actions as asp_action
from pygomas.agent import LONG_RECEIVE_WAIT

from pygomas.vector import Vector3D

from pygomas.ontology import (
    AIM,
    ANGLE,
    DEC_HEALTH,
    DISTANCE,
    FOV,
    HEAD_X,
    HEAD_Y,
    HEAD_Z,
    MAP,
    PACKS,
    QTY,
    SHOTS,
    VEL_X,
    TYPE,
    VEL_Y,
    VEL_Z,
    X,
    Y,
    Z,
    PERFORMATIVE,
    PERFORMATIVE_CFA,
    PERFORMATIVE_CFB,
    PERFORMATIVE_CFM,
    PERFORMATIVE_DATA,
    PERFORMATIVE_GAME,
    PERFORMATIVE_GET,
    PERFORMATIVE_INIT,
    PERFORMATIVE_MOVE,
    PERFORMATIVE_OBJECTIVE,
    PERFORMATIVE_SHOOT,
    AMMO_SERVICE,
    BACKUP_SERVICE,
    MEDIC_SERVICE,
    AMMO,
    BASE,
    CLASS,
    DESTINATION,
    ENEMIES_IN_FOV,
    FRIENDS_IN_FOV,
    FLAG,
    HEADING,
    HEALTH,
    NAME,
    MY_MEDICS,
    MY_FIELDOPS,
    MY_BACKUPS,
    PACKS_IN_FOV,
    PERFORMATIVE_PACK_TAKEN,
    PERFORMATIVE_TARGET_REACHED,
    PERFORMATIVE_FLAG_TAKEN,
    POSITION,
    TEAM,
    THRESHOLD_HEALTH,
    THRESHOLD_AMMO,
    THRESHOLD_AIM,
    THRESHOLD_SHOTS,
    VELOCITY,
)


from pygomas.agent import LONG_RECEIVE_WAIT

class BDIAdvancedSoldier(BDISoldier):

     def add_custom_actions(self, actions):
        super().add_custom_actions(actions)
        
        @actions.add_function(".elegirAscender", (tuple,))      
        #def _elegirAscender(listaSoldados):
        def _elegirAscender(listaSoldados):#listaSoldados,soldado):
            """
            Gives soldier in the middle
            :param number: list of soldiers
            :param type: type of the agents
            :rtype soldier
            """
            #args = asp.grounded(term.args, intention.scope)
            #listaSoldados = list(listaSoldados) + [str(soldado)]
    
            #pos = len(listaSoldados)//2
            #capi = listaSoldados[pos]
            #capi = list(capi)
            #print(capi)
            pos = (len(listaSoldados)) //2
            return listaSoldados[pos]
            
        
        @actions.add_function(".delete", (int, tuple, ))
        def _delete(p, l):
            if p==0:
                return l[1:]
            elif p == len(l) -1:
                return l[:p]
            else:
                return l[0:p] + l[p+1:]

